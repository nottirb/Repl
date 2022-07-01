-- Repl
-- Stephen Leitnick
-- August 05, 2021

--[=[
	@class Repl
	Remote data/event replication library.

	This exposes the raw functions that are used by the `ServerRepl` and `ClientRepl` classes.
	Those two classes should be preferred over accessing the functions directly through this
	Repl library.

	```lua
	-- Server
	local ServerRepl = require(ReplicatedStorage.Packages.Repl).ServerRepl
	local serverRepl = ServerRepl.new(somewhere, "MyRepl")
	serverRepl:BindFunction("Hello", function(player: Player)
		return "Hi"
	end)

	-- Client
	local ClientRepl = require(ReplicatedStorage.Packages.Repl).ClientRepl
	local clientRepl = ClientRepl.new(somewhere, false, "MyRepl")
	local repl = clientRepl:BuildObject()
	print(repl:Hello()) --> Hi
	```
]=]
local Repl = {
	Server = require(script.Server),
	Client = require(script.Client),
	ServerRepl = require(script.Server.ServerRepl),
	ClientRepl = require(script.Client.ClientRepl),
}

return Repl
