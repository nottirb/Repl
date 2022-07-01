# Credit

This library is based on `sleitnick/comm@0.3.0`

# Getting Started

This library can be acquired using [Wally](https://wally.run/), a package manager for Roblox.

## Wally Configuration
Once Wally is installed, run `wally init` on your project directory, and then add the various utility modules found here as dependencies. For example, the following could be a `wally.toml` file for a project that includes a few of these modules:
```toml
[package]
name = "your_name/your_project"
version = "0.1.0"
registry = "https://github.com/UpliftGames/wally-index"
realm = "shared"

[dependencies]
Repl = "nottirb/repl@0.0.1-beta"
```

To install these dependencies, run `wally install` within your project. Wally will create a Package folder in your directory with the installed dependencies.

## Rojo Configuration
The Package folder created by Wally should be synced into Roblox Studio through your Rojo configuration. For instance, a Rojo configuration might have the following entry to sync the Packages folder into ReplicatedStorage:
```json
{
	"name": "rbx-util-example",
	"tree": {
		"$className": "DataModel",
		"ReplicatedStorage": {
			"$className": "ReplicatedStorage",
			"Packages": {
				"$path": "Packages"
			}
		}
	}
}
```

## Usage Example
The installed library can now be used in scripts, such as the following:
```lua
-- Reference folder with packages:
local Packages = game:GetService("ReplicatedStorage").Packages

-- Require the library:
local Repl = require(Packages.Repl)

-- Use the libary:
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