"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[331],{3905:(e,n,t)=>{t.d(n,{Zo:()=>s,kt:()=>f});var r=t(67294);function a(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function l(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);n&&(r=r.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,r)}return t}function o(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?l(Object(t),!0).forEach((function(n){a(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):l(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function i(e,n){if(null==e)return{};var t,r,a=function(e,n){if(null==e)return{};var t,r,a={},l=Object.keys(e);for(r=0;r<l.length;r++)t=l[r],n.indexOf(t)>=0||(a[t]=e[t]);return a}(e,n);if(Object.getOwnPropertySymbols){var l=Object.getOwnPropertySymbols(e);for(r=0;r<l.length;r++)t=l[r],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(a[t]=e[t])}return a}var c=r.createContext({}),p=function(e){var n=r.useContext(c),t=n;return e&&(t="function"==typeof e?e(n):o(o({},n),e)),t},s=function(e){var n=p(e.components);return r.createElement(c.Provider,{value:n},e.children)},u={inlineCode:"code",wrapper:function(e){var n=e.children;return r.createElement(r.Fragment,{},n)}},d=r.forwardRef((function(e,n){var t=e.components,a=e.mdxType,l=e.originalType,c=e.parentName,s=i(e,["components","mdxType","originalType","parentName"]),d=p(t),f=a,y=d["".concat(c,".").concat(f)]||d[f]||u[f]||l;return t?r.createElement(y,o(o({ref:n},s),{},{components:t})):r.createElement(y,o({ref:n},s))}));function f(e,n){var t=arguments,a=n&&n.mdxType;if("string"==typeof e||a){var l=t.length,o=new Array(l);o[0]=d;var i={};for(var c in n)hasOwnProperty.call(n,c)&&(i[c]=n[c]);i.originalType=e,i.mdxType="string"==typeof e?e:a,o[1]=i;for(var p=2;p<l;p++)o[p]=t[p];return r.createElement.apply(null,o)}return r.createElement.apply(null,t)}d.displayName="MDXCreateElement"},76647:(e,n,t)=>{t.r(n),t.d(n,{contentTitle:()=>o,default:()=>s,frontMatter:()=>l,metadata:()=>i,toc:()=>c});var r=t(87462),a=(t(67294),t(3905));const l={},o="Credit",i={type:"mdx",permalink:"/Repl/",source:"@site/pages/index.md",title:"Credit",description:"This library is based on sleitnick/comm@0.3.0",frontMatter:{}},c=[{value:"Wally Configuration",id:"wally-configuration",level:2},{value:"Rojo Configuration",id:"rojo-configuration",level:2},{value:"Usage Example",id:"usage-example",level:2}],p={toc:c};function s(e){let{components:n,...t}=e;return(0,a.kt)("wrapper",(0,r.Z)({},p,t,{components:n,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"credit"},"Credit"),(0,a.kt)("p",null,"This library is based on ",(0,a.kt)("inlineCode",{parentName:"p"},"sleitnick/comm@0.3.0")),(0,a.kt)("h1",{id:"getting-started"},"Getting Started"),(0,a.kt)("p",null,"This library can be acquired using ",(0,a.kt)("a",{parentName:"p",href:"https://wally.run/"},"Wally"),", a package manager for Roblox."),(0,a.kt)("h2",{id:"wally-configuration"},"Wally Configuration"),(0,a.kt)("p",null,"Once Wally is installed, run ",(0,a.kt)("inlineCode",{parentName:"p"},"wally init")," on your project directory, and then add the various utility modules found here as dependencies. For example, the following could be a ",(0,a.kt)("inlineCode",{parentName:"p"},"wally.toml")," file for a project that includes a few of these modules:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-toml"},'[package]\nname = "your_name/your_project"\nversion = "0.1.0"\nregistry = "https://github.com/UpliftGames/wally-index"\nrealm = "shared"\n\n[dependencies]\nRepl = "nottirb/repl@0.0.1-beta"\n')),(0,a.kt)("p",null,"To install these dependencies, run ",(0,a.kt)("inlineCode",{parentName:"p"},"wally install")," within your project. Wally will create a Package folder in your directory with the installed dependencies."),(0,a.kt)("h2",{id:"rojo-configuration"},"Rojo Configuration"),(0,a.kt)("p",null,"The Package folder created by Wally should be synced into Roblox Studio through your Rojo configuration. For instance, a Rojo configuration might have the following entry to sync the Packages folder into ReplicatedStorage:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-json"},'{\n    "name": "rbx-util-example",\n    "tree": {\n        "$className": "DataModel",\n        "ReplicatedStorage": {\n            "$className": "ReplicatedStorage",\n            "Packages": {\n                "$path": "Packages"\n            }\n        }\n    }\n}\n')),(0,a.kt)("h2",{id:"usage-example"},"Usage Example"),(0,a.kt)("p",null,"The installed library can now be used in scripts, such as the following:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'-- Reference folder with packages:\nlocal Packages = game:GetService("ReplicatedStorage").Packages\n\n-- Require the library:\nlocal Repl = require(Packages.Repl)\n\n-- Use the libary:\n-- Server\nlocal ServerRepl = require(ReplicatedStorage.Packages.Repl).ServerRepl\nlocal serverRepl = ServerRepl.new(somewhere, "MyRepl")\nserverRepl:BindFunction("Hello", function(player: Player)\n    return "Hi"\nend)\n\n-- Client\nlocal ClientRepl = require(ReplicatedStorage.Packages.Repl).ClientRepl\nlocal clientRepl = ClientRepl.new(somewhere, false, "MyRepl")\nlocal repl = clientRepl:BuildObject()\nprint(repl:Hello()) --\x3e Hi\n')))}s.isMDXComponent=!0}}]);