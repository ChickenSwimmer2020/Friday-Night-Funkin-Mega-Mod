# Friday Night Funkin': Mega Mod
Welcome to the official page for the FNF':MM! this github page is well, to put it simply. store my source so i dont lose any to random crashes. but! this also means that you, might be able to play it! if you can build my mess of spaghetti code that is. so, i will be adding a list below to allow you to get all requiered plugins, so that if you really want to build my mod, you can! with all that said, enjoy my mess of spaghetti!

## BUILD INSTRUCTIONS
 BEFORE YOU DO ANYTHING, MAKE SURE YOU KNOW ABSOLUTLY WHAT YOUR DOING. I AM NOT LIABLE IF YOU BRICK YOUR ~~SYSTEM~~^this is a joke^ GAME WITH CRAPPY CODE.
 ### IDE
 to build the game, you will first need to install [Visual Studio Community 2022](https://visualstudio.microsoft.com/vs/community/), and [Visual Studio Code](https://code.visualstudio.com). make sure to after installing these, to run the [setup-msvs-win.bat](./setup/setup-msvc-win.bat) file to get required components to build the game. after that, run the [setup-windows.bat](./setup/setup-windows.bat) to get some plugins/libraries to build the game
 ### HAXE
  for literally ANY of this to work, you need to install haxe. haxe can be installed from [Haxe](https://haxe.org).
  ***AFTER INSTALLING, RUN*** `haxe setup` ***TO CHOOSE A FOLDER TO KEEP HAXE PLUGINS. PUT IT SOMEWHERE IT WONT GET LOST. I CANT STRESS THIS ENOUGH***
 ### LIME
  for the game to be buildable you will need lime. to get lime, simply run `Haxelib install lime` and after it installs, run `Haxelib run lime setup` to install lime fully
 ### PLUGINS/LIBRARYS
  these are extra plugins you will need. below in the sections, are the commands to install, and can be pasted with `Control + shift + v`
  most of these got installed with the setup-windows.bat file you ran earlier, so if it says that `[COMPONENT] is already installed` then you dont need to do anything and can skip that one. however, ***DO NOT SKIP*** the HxCodec command, as you ***REQUIRE*** HxCodec 2.6.0 to build the game. dont cry if you cant get the video state to work if you didnt downgrade to 2.6.0.
  #### discord
    yes. install both. they both have bug fixes for the other.
    * haxelib install discord_rpc 1.0.0
    * haxelib install discord-rpc 1.0.0
    * haxelib install hxdiscord_rpc
  #### haxe
    * haxelib install hxCodec 2.6.0
    * haxelib install hxcpp
    * haxelib install hxcpp-debug-server
    * haxelib install hxvlc
    * haxelib install nape-haxe4
  #### flixel
    most of these probably already got installed, but just incase.
    * haxelib install flixel
    * haxelib install flixel-addons
    * haxelib install flixel-tools
    * haxelib install flixel-ui
    * haxelib install flxanimate
    * haxelib install
  #### thx
    these have a seperate catagory because there is a lot of them...
    * haxelib install thx.core
    * haxelib install thx.color
    * haxelib install thx.promise
    * haxelib install thx.unit
    * haxelib install thx.semver
    * haxelib install thx.stream
    * haxelib install thx.culture
    * haxelib install thx.format
    * haxelib install sui
    * haxelib install thx.stream.dom
    * haxelib install thx.benchmark
    * haxelib install thx.csv
    * haxelib install thx.text
    * haxelib install thx.tpl
  #### extras
   the other plugins that dont have catagories
   * haxelib install hmm
   * haxelib install HtmlParser
   * haxelib install hscript
   * haxelib install linc_luajit
   * haxelib install openfl
   * haxelib install parallaxlt
   * haxelib install polymod
   * haxelib install SScript
   * haxelib install tjson
   * haxelib install utest
 ### ACTUALLY BUILDING
  #### LOADING
    once you have install visual studio, go to your downloaded source folder. and right click on the folder. click more options, then click `open in visual studio`. then the IDE will open.
  #### build
    once you have installed all the required plugins/librarys. simply go to the powershell console, and type `lime test windows -debug` for debug, or `lime test windows` to test release. if you want to build to an .exe file, simply type `lime build windows` or `lime build windows -debug`
# EVERYTHING BELOW THIS IS THE DEFAULT README.MD
## Friday Night Funkin' - Psych Engine
Engine originally used on [Mind Games Mod](https://gamebanana.com/mods/301107), intended to be a fix for the vanilla version's many issues while keeping the casual play aspect of it. Also aiming to be an easier alternative to newbie coders.

### Customization:

if you wish to disable things like *Lua Scripts* or *Video Cutscenes*, you can read over to `Project.xml`

inside `Project.xml`, you will find several variables to customize Psych Engine to your liking

to start you off, disabling Videos should be simple, simply Delete the line `"VIDEOS_ALLOWED"` or comment it out by wrapping the line in XML-like comments, like this `<!-- YOUR_LINE_HERE -->`

same goes for *Lua Scripts*, comment out or delete the line with `LUA_ALLOWED`, this and other customization options are all available within the `Project.xml` file

### Credits:
* Shadow Mario - Programmer
* Riveren - Artist

### Special Thanks
* bbpanzu - Ex-Programmer
* Yoshubs - Ex-Programmer
* SqirraRNG - Crash Handler and Base code for Chart Editor's Waveform
* KadeDev - Fixed some cool stuff on Chart Editor and other PRs
* iFlicky - Composer of Psync and Tea Time, also made the Dialogue Sounds
* PolybiusProxy - .MP4 Video Loader Library (hxCodec)
* Keoiki - Note Splash Animations
* Smokey - Sprite Atlas Support
* Nebula the Zorua - some Lua reworks
* superpowers04 - LUA JIT Fork
_____________________________________

### Features

#### Attractive animated dialogue boxes:

![](https://user-images.githubusercontent.com/44785097/127706669-71cd5cdb-5c2a-4ecc-871b-98a276ae8070.gif)


#### Mod Support
* Probably one of the main points of this engine, you can code in .lua files outside of the source code, making your own weeks without even messing with the source!
* Comes with a Mod Organizing/Disabling Menu.


#### Atleast one change to every week:
##### Week 1:
  * New Dad Left sing sprite
  * Unused stage lights are now used
  * Dad Battle has a spotlight effect for the breakdown
##### Week 2:
  * Both BF and Skid & Pump does "Hey!" animations
  * Thunders does a quick light flash and zooms the camera in slightly
  * Added a quick transition/cutscene to Monster
##### Week 3:
  * BF does "Hey!" during Philly Nice
  * Blammed has a cool new colors flash during that sick part of the song
##### Week 4:
  * Better hair physics for Mom/Boyfriend (Maybe even slightly better than Week 7's :eyes:)
  * Henchmen die during all songs. Yeah :(
##### Week 5:
  * Bottom Boppers and GF does "Hey!" animations during Cocoa and Eggnog
  * On Winter Horrorland, GF bops her head slower in some parts of the song.
##### Week 6:
  * On Thorns, the HUD is hidden during the cutscene
  * Also there's the Background girls being spooky during the "Hey!" parts of the Instrumental

#### Cool new Chart Editor changes and countless bug fixes
![](https://github.com/ShadowMario/FNF-PsychEngine/blob/main/docs/img/chart.png?raw=true)
* You can now chart "Event" notes, which are bookmarks that trigger specific actions that usually were hardcoded on the vanilla version of the game.
* Your song's BPM can now have decimal values
* You can manually adjust a Note's strum time if you're really going for milisecond precision
* You can change a note's type on the Editor, it comes with five example types:
  * Alt Animation: Forces an alt animation to play, useful for songs like Ugh/Stress
  * Hey: Forces a "Hey" animation instead of the base Sing animation, if Boyfriend hits this note, Girlfriend will do a "Hey!" too.
  * Hurt Notes: If Boyfriend hits this note, he plays a miss animation and loses some health.
  * GF Sing: Rather than the character hitting the note and singing, Girlfriend sings instead.
  * No Animation: Character just hits the note, no animation plays.

#### Multiple editors to assist you in making your own Mod
![Screenshot_3](https://user-images.githubusercontent.com/44785097/144629914-1fe55999-2f18-4cc1-bc70-afe616d74ae5.png)
* Working both for Source code modding and Downloaded builds!

#### Story mode menu rework:
![](https://i.imgur.com/UB2EKpV.png)
* Added a different BG to every song (less Tutorial)
* All menu characters are now in individual spritesheets, makes modding it easier.

#### Credits menu
![Screenshot_1](https://user-images.githubusercontent.com/44785097/144632635-f263fb22-b879-4d6b-96d6-865e9562b907.png)
* You can add a head icon, name, description and a Redirect link for when the player presses Enter while the item is currently selected.

#### Awards/Achievements
* The engine comes with 16 example achievements that you can mess with and learn how it works (Check Achievements.hx and search for "checkForAchievement" on PlayState.hx)

#### Options menu:
* You can change Note colors, Delay and Combo Offset, Controls and Preferences there.
 * On Preferences you can toggle Downscroll, Middlescroll, Anti-Aliasing, Framerate, Low Quality, Note Splashes, Flashing Lights, etc.

#### Other gameplay features:
* When the enemy hits a note, their strum note also glows.
* Lag doesn't impact the camera movement and player icon scaling anymore.
* Some stuff based on Week 7's changes has been put in (Background colors on Freeplay, Note splashes)
* You can reset your Score on Freeplay/Story Mode by pressing Reset button.
* You can listen to a song or adjust Scroll Speed/Damage taken/etc. on Freeplay by pressing Space.
* You can enable "Combo Stacking" in Gameplay Options. This causes the combo sprites to just be one sprite with an animation rather than sprites spawning each note hit.
