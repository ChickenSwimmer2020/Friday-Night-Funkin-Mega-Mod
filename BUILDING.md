BEFORE YOU DO ANYTHING, MAKE SURE YOU KNOW ABSOLUTLY WHAT YOUR DOING. I AM NOT LIABLE IF YOU BRICK YOUR ~~SYSTEM~~<sup>this is a joke</sup> GAME WITH CRAPPY CODE.

### IDE

to build the game, you will first need to install [Visual Studio Community 2022](https://visualstudio.microsoft.com/vs/community/), and [Visual Studio Code](https://code.visualstudio.com). make sure to after installing these, to run the [setup-msvs-win.bat](./setup/setup-msvc-win.bat) file to get required components to build the game. after that, run the [setup-windows.bat](./setup/setup-windows.bat) to get some plugins/libraries to build the game

### HAXE

for literally ANY of this to work, you need to install haxe. haxe can be installed from [Haxe](https://haxe.org).

***AFTER INSTALLING, RUN***  `haxelib setup`  ***TO CHOOSE A FOLDER TO KEEP HAXE PLUGINS. PUT IT SOMEWHERE IT WONT GET LOST. I CANT STRESS THIS ENOUGH***

### LIME

for the game to actually be buildable you will need lime. to get lime, simply run `Haxelib install lime` and after it installs, run `Haxelib run lime setup` to install lime fully

### PLUGINS/LIBRARYS

these are extra plugins you will need. below in the sections, are the commands to install, and can be pasted with `Control + shift + v`

most of these got installed with the setup-windows.bat file you ran earlier, so if it says that `[COMPONENT] is already installed` then you don't need to do anything and can skip that one. however, ***DO NOT SKIP*** the HxCodec command, as you ***REQUIRE*** HxCodec 2.6.0 to build the game. don't cry in the issues page if you cant get the video state to work if you didn't downgrade to 2.6.0.

#### discord

yes. install both. they both have bug fixes for the other.

* haxelib install discord_rpc 1.0.0

* haxelib install discord-rpc 1.0.0

* haxelib install hxdiscord_rpc 1.1.1

#### haxe

* haxelib install HxCodec 2.6.0

* haxelib install hxcpp 4.3.2

* haxelib install hxcpp-debug-server 1.2.4

* haxelib install hxvlc 1.5.5

* haxelib install nape-haxe4 2.0.22

#### flixel

most of these probably already got installed, but just incase.

* haxelib install flixel 5.8.0 

* haxelib install flixel-demos 3.2.0

* haxelib install flixel-addons 3.2.3

* haxelib install flixel-templates 2.7.0

* haxelib install flixel-tools 1.5.1 

* haxelib install flixel-ui 2.6.1

* haxelib git flxanimate https://github.com/Dot-Stuff/flxanimate

#### thx
don't know what these do really, but it must be important
* haxelib install thx. Core 0.44.0

* haxelib install thx.semver 0.2.2

#### extras

the other plugins that don't have categories

* haxelib install callfunc 0.4.1

* haxelib install safety 1.1.2

* haxelib install unifill 0.4.1

* haxelib install hmm 3.1.0

* haxelib install HtmlParser 3.4.0

* haxelib install hscript 2.5.0

* haxelib git linc_luajit https://github.com/AndreiRudenko/linc_luajit

* haxelib install openfl 9.3.3

* haxelib install parallaxlt 0.0.4

* haxelib install polymod 1.7.0

* haxelib install SScript 20.8.618

* haxelib install tjson 1.4.0

* haxelib install utest 1.13.2

### ACTUALLY BUILDING

#### LOADING

once you have install visual studio, go to your downloaded source folder, and right click on the folder.

click more options, then click `open in visual studio`. then the IDE will open.

#### build

once you have installed all the required plugins/libraries. simply go to the PowerShell console, and type `lime test windows -debug`

for debug, or `lime test windows` to test release. if you want to build to an .exe file, simply type `lime build windows` or `lime build windows -debug`

  
