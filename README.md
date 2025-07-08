WORK IN PROGRESS!!!
TO DO:
- Test it in multiplayer (Havent had time yet, woops)
- Add second lifeform option (Yes, the icons would be a little small but this one will be toggled in a config file).

Natural Selection 2 Plugin "commissioned" by Bleu

This plugin displays your lifeform icon on your scoreboard tab while on warmup. It allows players on the alien team to communicate better by letting them choose what lifeform they desire to play along the match. 
I choosed to make it the long way by hooking specific methods instead of replacing, because i wanted to persue full compatibilty with devnull's enhanced scoreboard plugin and with whatever other plugins interact with the GUIScoreboard.lua.
A summarized explanation follows at the end of this readme.

RULES OF USE:
- none, you're 100% free to include this in your bigger-mod-pack.
- credit would be appreciated but i dont care honestly, just dont credit yourself i guess. It's just a simple plugin anyways.

@ Explanation:
i used a reference to the unmodified versions of the methods i needed to hook at, before doing anything, and firing them before my stuff comes in. 
The reason i did this, is because many servers run shine and devnulls plugins, which in some way or another end up changing some stuff there. And making my plugin compatible with the most used is a must have. 

Hovermenus show this way; first the GUIScoreboard:sendkeyevent method pulls the current key pressed by the user. in this method we can find the logic that manages the "Steam profile" button and the "NS2Panel Profile" (Which is added by Devnull's enhanced scoreboard)
It basically uses a method called "GUIItemContainsPoint", which must receive a parameter for the gui item, and we can also send two more parameters for the mouseX and mouseY. We fire this method onclick and checking if the scoreboard is visible of course. 
Once the method has been fired with an if statement, we flush the previously shown hovermenu buttons with hovermenu:resetbuttons (When we click on our own "playerItem" or other's "playerItem" in the scoreboard, the default options show, but there's a hovermenu:resetbuttons method that is called every time we open the menu so they dont infinitely get added). This way we can add our own buttons and not show the default ones.
The addbutons method receives a parameter which is the method we want called after we click on the buttons. You can add whatever you like there. In my case, i was using the same asset in different coordinates for every lifeform, so i had to change the texture coordinates depending on that.
As for the icon visibility, first i hooked into guiscoreboard create player item. This function returns a "playerItem". So what i did is to receive the output of the original function as a local reference, create my own gui graphic item, and child it to the playeritem main item (which is the background). Then, i returned the playerItem as normal (This way, it works flawleslly with other mods that might add something else, or replace stuff within the original method)

Then, i hooked into the guiscoreboard update and checked for 
1 - Guiscoreboard visibility (self.visible)
2 - Self_player reference valid and in alien team
3 - Warmup gamemode is running


Once the conditions are met, i use a for bucle on the playerlist. 
In order to bucle the playerlist you must first refernce the team on which you want to cycle through with local playerList = self.teams[TEAMNUMBER]["PlayerList"]

Team number = 1 stands for spec
Team number = 2 stands for marine
Team number = 3 stands for alien 

If you need it, you can use another for bucle and cycle through all the teams or just the marine / alien. 

Then, you must cycle through the received playerlist table with another for bucle, using playerlist lenght (for p = 1, #playerList) you receive your playeritems like this (local playerItem = playerList[p])
Once there, for each player you receive you must set their added icon to visible

Also, you will find "flushes" in the code, these ensure things are cleaned when they shouldnt display. You may also find some state machines i had to make in order to contain the current state of the game.
