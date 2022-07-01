"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[331],{6647:function(e,n,l){l.r(n),l.d(n,{frontMatter:function(){return o},contentTitle:function(){return c},metadata:function(){return p},toc:function(){return s},default:function(){return d}});var a=l(7462),t=l(3366),r=(l(7294),l(3905)),i=["components"],o={},c="Credit",p={type:"mdx",permalink:"/Repl/",source:"@site/pages/index.md"},s=[{value:"Wally Configuration",id:"wally-configuration",children:[],level:2},{value:"Rojo Configuration",id:"rojo-configuration",children:[],level:2},{value:"Usage Example",id:"usage-example",children:[],level:2}],u={toc:s};function d(e){var n=e.components,l=(0,t.Z)(e,i);return(0,r.kt)("wrapper",(0,a.Z)({},u,l,{components:n,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"credit"},"Credit"),(0,r.kt)("p",null,"This library is based on ",(0,r.kt)("inlineCode",{parentName:"p"},"sleitnick/comm@0.3.0")),(0,r.kt)("h1",{id:"getting-started"},"Getting Started"),(0,r.kt)("p",null,"This library can be acquired using ",(0,r.kt)("a",{parentName:"p",href:"https://wally.run/"},"Wally"),", a package manager for Roblox."),(0,r.kt)("h2",{id:"wally-configuration"},"Wally Configuration"),(0,r.kt)("p",null,"Once Wally is installed, run ",(0,r.kt)("inlineCode",{parentName:"p"},"wally init")," on your project directory, and then add the various utility modules found here as dependencies. For example, the following could be a ",(0,r.kt)("inlineCode",{parentName:"p"},"wally.toml")," file for a project that includes a few of these modules:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-toml"},'[package]\nname = "your_name/your_project"\nversion = "0.1.0"\nregistry = "https://github.com/UpliftGames/wally-index"\nrealm = "shared"\n\n[dependencies]\nRepl = "nottirb/repl@0.0.1-beta"\n')),(0,r.kt)("p",null,"To install these dependencies, run ",(0,r.kt)("inlineCode",{parentName:"p"},"wally install")," within your project. Wally will create a Package folder in your directory with the installed dependencies."),(0,r.kt)("h2",{id:"rojo-configuration"},"Rojo Configuration"),(0,r.kt)("p",null,"The Package folder created by Wally should be synced into Roblox Studio through your Rojo configuration. For instance, a Rojo configuration might have the following entry to sync the Packages folder into ReplicatedStorage:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-json"},'{\n    "name": "rbx-util-example",\n    "tree": {\n        "$className": "DataModel",\n        "ReplicatedStorage": {\n            "$className": "ReplicatedStorage",\n            "Packages": {\n                "$path": "Packages"\n            }\n        }\n    }\n}\n')),(0,r.kt)("h2",{id:"usage-example"},"Usage Example"),(0,r.kt)("p",null,"The installed library can now be used in scripts, such as the following:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'-- Reference folder with packages:\nlocal Packages = game:GetService("ReplicatedStorage").Packages\n\n-- Require the library:\nlocal Repl = require(Packages.Repl)\n\n-- Use the libary:\n-- Server\nlocal ServerRepl = require(ReplicatedStorage.Packages.Repl).ServerRepl\nlocal serverRepl = ServerRepl.new(somewhere, "MyRepl")\nserverRepl:BindFunction("Hello", function(player: Player)\n    return "Hi"\nend)\n\n-- Client\nlocal ClientRepl = require(ReplicatedStorage.Packages.Repl).ClientRepl\nlocal clientRepl = ClientRepl.new(somewhere, false, "MyRepl")\nlocal repl = clientRepl:BuildObject()\nprint(repl:Hello()) --\x3e Hi\n')))}d.isMDXComponent=!0}}]);