# [SECTION 1: GOALS AND EXITS]

Flagpoles advance to the next level, axes advance to the next world. The green ball is what defines the flagpole. The flagpole is exactly 7 tiles tall, excluding the block at the bottom and ball.

# [SECTION 2: PIPES]

This part is confusing. All Sideways pipes are enterable, and need the screen to be defined. Screens are horizontal chunks of 16 tiles. Subareas are named as W-L.S.tmx. Warp zones will be explained in the JSON formatting section...which is next.

# [SECTION 3: JSON FORMATTING]

So the json is stored as a structure, with the names formatted as W-L.S.

There's four values the "levelTheme" property can be. 0 = Overworld, 1 = Underground, 2 = Underwater, and 3 = Castle.

Then there's level dimensions. "levelHeight" and "levelWidth" are what they say.

"bgCol" defines the color at which the level background is as a hex string. The common colors are "9494ff" and "000000."

The properties "marioX" and "marioY" define where in the level mario starts.

"pipes" is an array of numbers per each screen. Each value determines which subarea that the level goes to.

"pipescreen" determines how many screens in the area mario is sent.

If you set any value in the pipescreen or pipes to an array, that screen is treated as a warp zone. These only go up to 3 values, for each pipe.

Then there is the "song" property, which determines what song to play. The values are the same as theme, plus 5 = Star, and beyond can be added new songs.

There is the "intermission" property, which treats that area like the beginning of 1-2, 2-2, 4-2, and 7-2.

"underwater" treats the entire level as if it is underwater. Yes, the tiles are only decoration.

We finaly have "direction" which, 0 = No Scrolling, 1 = Right only, 2 = Left Only, and 3 = Both directions.

# [SECTION 4: TMX USAGE]

For tiles, it's as simple as place them down where they go. For enemies, if the icon is cut in half, it's shifted over 8 pixels. When done with the level, Export as a csv, with Ctrl + Shift + E. Name the file as said before, W-L.S, with W = World, L = Level, and S = Sublevel.