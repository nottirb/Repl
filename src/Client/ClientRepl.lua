-- ClientRepl
-- Stephen Leitnick
-- December 20, 2021

local Repl = require(script.Parent)
local Util = require(script.Parent.Parent.Util)
local Types = require(script.Parent.Parent.Types)

--[=[
	@class ClientRepl
	@client
]=]
local ClientRepl = {}
ClientRepl.__index = ClientRepl

--[=[
	@within ClientRepl
	@type ClientMiddlewareFn (args: {any}) -> (shouldContinue: boolean, ...: any)
	The middleware function takes the arguments (as a table array), and should
	return `true|false` to indicate if the process should continue.

	If returning `false`, the optional varargs after the `false` are used as the new return values
	to whatever was calling the middleware.
]=]
--[=[
	@within ClientRepl
	@type ClientMiddleware {ClientMiddlewareFn}
	Array of middleware functions.
]=]

--[=[
	@return ClientRepl
	Constructs a ClientRepl object.

	If `usePromise` is set to `true`, then `GetFunction` will generate a function that returns a Promise
	that resolves with the server response. If set to `false`, the function will act like a normal
	call to a RemoteFunction and yield until the function responds.

	```lua
	local clientRepl = ClientRepl.new(game:GetService("ReplicatedStorage"), true)

	-- If using a unique namespace with ServerRepl, include it as second argument:
	local clientRepl = ClientRepl.new(game:GetService("ReplicatedStorage"), true, "MyNamespace")
	```
]=]
function ClientRepl.new(parent: Instance, usePromise: boolean, namespace: string?)
	assert(not Util.IsServer, "ClientRepl must be constructed from the client")
	assert(typeof(parent) == "Instance", "Parent must be of type Instance")
	local ns = Util.DefaultReplFolderName
	if namespace then
		ns = namespace
	end
	local folder: Instance? = parent:WaitForChild(ns, Util.WaitForChildTimeout)
	assert(folder ~= nil, "Could not find namespace for ClientRepl in parent: " .. ns)
	local self = setmetatable({}, ClientRepl)
	self._instancesFolder = folder
	self._usePromise = usePromise
	return self
end

--[=[
	@param name string
	@param inboundMiddleware ClientMiddleware?
	@param outboundMiddleware ClientMiddleware?
	@return (...: any) -> any

	Generates a function on the matching RemoteFunction generated with ServerRepl. The function
	can then be called to invoke the server. If this `ClientRepl` object was created with
	the `usePromise` parameter set to `true`, then this generated function will return
	a Promise when called.

	```lua
	-- Server-side:
	local serverRepl = ServerRepl.new(someParent)
	serverRepl:BindFunction("MyFunction", function(player, msg)
		return msg:upper()
	end)

	-- Client-side:
	local clientRepl = ClientRepl.new(someParent)
	local myFunc = clientRepl:GetFunction("MyFunction")
	local uppercase = myFunc("hello world")
	print(uppercase) --> HELLO WORLD

	-- Client-side, using promises:
	local clientRepl = ClientRepl.new(someParent, true)
	local myFunc = clientRepl:GetFunction("MyFunction")
	myFunc("hi there"):andThen(function(msg)
		print(msg) --> HI THERE
	end):catch(function(err)
		print("Error:", err)
	end)
	```
]=]
function ClientRepl:GetFunction(
	name: string,
	inboundMiddleware: Types.ClientMiddleware?,
	outboundMiddleware: Types.ClientMiddleware?
)
	return Repl.GetFunction(self._instancesFolder, name, self._usePromise, inboundMiddleware, outboundMiddleware)
end

--[=[
	@param name string
	@param inboundMiddleware ClientMiddleware?
	@param outboundMiddleware ClientMiddleware?
	@return ClientRemoteSignal
	Returns a new ClientRemoteSignal that mirrors the matching RemoteSignal created by
	ServerRepl with the same matching `name`.

	```lua
	local mySignal = clientRepl:GetSignal("MySignal")

	-- Listen for data from the server:
	mySignal:Connect(function(message)
		print("Received message from server:", message)
	end)

	-- Send data to the server:
	mySignal:Fire("Hello!")
	```
]=]
function ClientRepl:GetSignal(
	name: string,
	inboundMiddleware: Types.ClientMiddleware?,
	outboundMiddleware: Types.ClientMiddleware?
)
	return Repl.GetSignal(self._instancesFolder, name, inboundMiddleware, outboundMiddleware)
end

--[=[
	@param name string
	@param inboundMiddleware ClientMiddleware?
	@param outboundMiddleware ClientMiddleware?
	@return ClientRemoteProperty
	Returns a new ClientRemoteProperty that mirrors the matching RemoteProperty created by
	ServerRepl with the same matching `name`.

	Take a look at the ClientRemoteProperty documentation for more info, such as
	understanding how to wait for data to be ready.

	```lua
	local mapInfo = clientRepl:GetProperty("MapInfo")

	-- Observe the initial value of mapInfo, and all subsequent changes:
	mapInfo:Observe(function(info)
		print("Current map info", info)
	end)

	-- Check to see if data is initially ready:
	if mapInfo:IsReady() then
		-- Get the data:
		local info = mapInfo:Get()
	end

	-- Get a promise that resolves once the data is ready (resolves immediately if already ready):
	mapInfo:OnReady():andThen(function(info)
		print("Map info is ready with info", info)
	end)

	-- Same as above, but yields thread:
	local success, info = mapInfo:OnReady():await()
	```
]=]
function ClientRepl:GetProperty(
	name: string,
	inboundMiddleware: Types.ClientMiddleware?,
	outboundMiddleware: Types.ClientMiddleware?
)
	return Repl.GetProperty(self._instancesFolder, name, inboundMiddleware, outboundMiddleware)
end

--[=[
	@param inboundMiddleware ClientMiddleware?
	@param outboundMiddleware ClientMiddleware?
	@return table
	Returns an object which maps RemoteFunctions as methods
	and RemoteEvents as fields.
	```lua
	-- Server-side:
	serverRepl:BindFunction("Test", function(player) end)
	serverRepl:CreateSignal("MySignal")
	serverRepl:CreateProperty("MyProperty", 10)

	-- Client-side
	local obj = clientRepl:BuildObject()
	obj:Test()
	obj.MySignal:Connect(function(data) end)
	obj.MyProperty:Observe(function(value) end)
	```
]=]
function ClientRepl:BuildObject(inboundMiddleware: Types.ClientMiddleware?, outboundMiddleware: Types.ClientMiddleware?)
	local obj = {}
	local rfFolder = self._instancesFolder:FindFirstChild("RF")
	local reFolder = self._instancesFolder:FindFirstChild("RE")
	local rpFolder = self._instancesFolder:FindFirstChild("RP")
	if rfFolder then
		for _, rf in ipairs(rfFolder:GetChildren()) do
			if not rf:IsA("RemoteFunction") then
				continue
			end
			local f = self:GetFunction(rf.Name, inboundMiddleware, outboundMiddleware)
			obj[rf.Name] = function(_self, ...)
				return f(...)
			end
		end
	end
	if reFolder then
		for _, re in ipairs(reFolder:GetChildren()) do
			if not re:IsA("RemoteEvent") then
				continue
			end
			obj[re.Name] = self:GetSignal(re.Name, inboundMiddleware, outboundMiddleware)
		end
	end
	if rpFolder then
		for _, re in ipairs(rpFolder:GetChildren()) do
			if not re:IsA("RemoteEvent") then
				continue
			end
			obj[re.Name] = self:GetProperty(re.Name, inboundMiddleware, outboundMiddleware)
		end
	end
	return obj
end

--[=[
	Destroys the ClientRepl object.
]=]
function ClientRepl:Destroy() end

return ClientRepl
