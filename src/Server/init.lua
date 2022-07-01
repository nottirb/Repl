local Util = require(script.Parent.Util)
local RemoteSignal = require(script.RemoteSignal)
local RemoteProperty = require(script.RemoteProperty)
local Types = require(script.Parent.Types)

local Server = {}

--[=[
	@within Repl
	@prop ServerRepl ServerRepl
]=]
--[=[
	@within Repl
	@prop ClientRepl ClientRepl
]=]

--[=[
	@within Repl
	@private
	@interface Server
	.BindFunction (parent: Instance, name: string, fn: FnBind, inboundMiddleware: ServerMiddleware?, outboundMiddleware: ServerMiddleware?): RemoteFunction
	.WrapMethod (parent: Instance, tbl: table, name: string, inboundMiddleware: ServerMiddleware?, outboundMiddleware: ServerMiddleware?): RemoteFunction
	.CreateSignal (parent: Instance, name: string, inboundMiddleware: ServerMiddleware?, outboundMiddleware: ServerMiddleware?): RemoteSignal
	.CreateProperty (parent: Instance, name: string, value: any, inboundMiddleware: ServerMiddleware?, outboundMiddleware: ServerMiddleware?): RemoteProperty
	Server Repl
]=]
--[=[
	@within Repl
	@private
	@interface Client
	.GetFunction (parent: Instance, name: string, usePromise: boolean, inboundMiddleware: ClientMiddleware?, outboundMiddleware: ClientMiddleware?): (...: any) -> any
	.GetSignal (parent: Instance, name: string, inboundMiddleware: ClientMiddleware?, outboundMiddleware: ClientMiddleware?): ClientRemoteSignal
	.GetProperty (parent: Instance, name: string, inboundMiddleware: ClientMiddleware?, outboundMiddleware: ClientMiddleware?): ClientRemoteProperty
	Client Repl
]=]

function Server.BindFunction(
	parent: Instance,
	name: string,
	func: Types.FnBind,
	inboundMiddleware: Types.ServerMiddleware?,
	outboundMiddleware: Types.ServerMiddleware?
): RemoteFunction
	assert(Util.IsServer, "BindFunction must be called from the server")
	local folder = Util.GetReplSubFolder(parent, "RF"):Expect("Failed to get Repl RF folder")
	local rf = Instance.new("RemoteFunction")
	rf.Name = name
	local hasInbound = type(inboundMiddleware) == "table" and #inboundMiddleware > 0
	local hasOutbound = type(outboundMiddleware) == "table" and #outboundMiddleware > 0
	local function ProcessOutbound(player, ...)
		local args = table.pack(...)
		for _, middlewareFunc in ipairs(outboundMiddleware) do
			local middlewareResult = table.pack(middlewareFunc(player, args))
			if not middlewareResult[1] then
				return table.unpack(middlewareResult, 2, middlewareResult.n)
			end
			args.n = #args
		end
		return table.unpack(args, 1, args.n)
	end
	if hasInbound and hasOutbound then
		local function OnServerInvoke(player, ...)
			local args = table.pack(...)
			for _, middlewareFunc in ipairs(inboundMiddleware) do
				local middlewareResult = table.pack(middlewareFunc(player, args))
				if not middlewareResult[1] then
					return table.unpack(middlewareResult, 2, middlewareResult.n)
				end
				args.n = #args
			end
			return ProcessOutbound(player, func(player, table.unpack(args, 1, args.n)))
		end
		rf.OnServerInvoke = OnServerInvoke
	elseif hasInbound then
		local function OnServerInvoke(player, ...)
			local args = table.pack(...)
			for _, middlewareFunc in ipairs(inboundMiddleware) do
				local middlewareResult = table.pack(middlewareFunc(player, args))
				if not middlewareResult[1] then
					return table.unpack(middlewareResult, 2, middlewareResult.n)
				end
				args.n = #args
			end
			return func(player, table.unpack(args, 1, args.n))
		end
		rf.OnServerInvoke = OnServerInvoke
	elseif hasOutbound then
		local function OnServerInvoke(player, ...)
			return ProcessOutbound(player, func(player, ...))
		end
		rf.OnServerInvoke = OnServerInvoke
	else
		rf.OnServerInvoke = func
	end
	rf.Parent = folder
	return rf
end

function Server.WrapMethod(
	parent: Instance,
	tbl: {},
	name: string,
	inboundMiddleware: Types.ServerMiddleware?,
	outboundMiddleware: Types.ServerMiddleware?
): RemoteFunction
	assert(Util.IsServer, "WrapMethod must be called from the server")
	local fn = tbl[name]
	assert(type(fn) == "function", "Value at index " .. name .. " must be a function; got " .. type(fn))
	return Server.BindFunction(parent, name, function(...)
		return fn(tbl, ...)
	end, inboundMiddleware, outboundMiddleware)
end

function Server.CreateSignal(
	parent: Instance,
	name: string,
	inboundMiddleware: Types.ServerMiddleware?,
	outboundMiddleware: Types.ServerMiddleware?
)
	assert(Util.IsServer, "CreateSignal must be called from the server")
	local folder = Util.GetReplSubFolder(parent, "RE"):Expect("Failed to get Repl RE folder")
	local rs = RemoteSignal.new(folder, name, inboundMiddleware, outboundMiddleware)
	return rs
end

function Server.CreateProperty(
	parent: Instance,
	name: string,
	initialValue: any,
	inboundMiddleware: Types.ServerMiddleware?,
	outboundMiddleware: Types.ServerMiddleware?
)
	assert(Util.IsServer, "CreateProperty must be called from the server")
	local folder = Util.GetReplSubFolder(parent, "RP"):Expect("Failed to get Repl RP folder")
	local rp = RemoteProperty.new(folder, name, initialValue, inboundMiddleware, outboundMiddleware)
	return rp
end

return Server
