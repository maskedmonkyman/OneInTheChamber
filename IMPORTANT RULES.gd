#-------------------------------- Editor --------------------------------
#tile base size is 32x32 pixels
#
#all scene nodes should be camelCase, this is to avoid name conflicts with node types in scripts
#
#collision layers:
#	layer 1: level
#	layer 2: player
#	layer 3: enemies
#	layer 4: guns
#
#------------------------------- Hierarchy ------------------------------
#all character bodies must have a kinematic body as their base node
#
#all levels must inherit from BaseLevel
#	-the top of base level's scene tree (and therfore the top level parent for anything in that level) 
#	 is the "navigation2D" node
#	-the navigation2D node holds the "levelManagerScript" script, this script is responsible for
#	 high level game state functionality like win/loss and menus. Any gameplay behavior/system which
#	 requires these systems/functions should be done via interfacing through the levelManager's 
#	 functions and variables
#	-tl:dr all game state is handled by the levelManager do not do it in character or other scripts
#
#all guns inherit from GunBase, which holds a reference to a bullet. To fire a gun call it's fire method and
#pass it the angle it should be pointing. To change the bullet type of a gun make a new Bullet from BulletBase
#and modify it accordingly
#
#-------------------------------- Script --------------------------------
#non constant variables and methods are camelCase
#
#constants are PascalCase
#
#if a function is more than 30 lines check to see if it can be broken down into smaller functions
#
#please attempt to give meaningful variable names and comment out code
#
#where possible try to give a one line comment after functions, if statements, or 
# variable modification/declaration
#example:
#	var meaningfulVarName : type(optional) = someValue #comment explaining what this var does
#	func meaningfulFuncName(): # comment explaining what this function does
#	if(a bool): #what this branch checks for/should do if it succeeds
#
#top level variable declarations go in the following order: constants, enums, exports, regular vars, onreadys
#
#variable naming conventions:
#	pos = position : Vector2
#	dir = direction : Vector2 (should be normalized)
#	vec = Vector : Vector2
#	ang = angle : number (should be in degrees)
#	rot = rotation : number (should be in radians)
#	dist = distance : number
#
#------------------------ ToDo and ideas/thoughts -----------------------
#ToDo: (in sort of order of importance)
#	1:burn large parts of the enemy script with fire
#		-make enemies use some sort of state machine for behaviors
#		-consider reworking enemy collision (do they need wall collision?)
#		-implement flocking/steering? 
#		
#	2:start writing out levelManagerScript
#		-implement pausing
#		-implement game state stuff:
#			-the level manager should query it's children for number of enemies to see if we should move
#			 to the next level or not
#			-the level manager should query it's children for the number of available guns on the level
#			 (if a guns gunOwner is null and player fired is false then it should be considered available)
#			-handle loosing and level transitions
#	3:sounds in various places
#       - Note: Gun sounds added 
#	4:profit?
#	5:gun lasers (ray trace)
#	6:player anim stuff
#		-throw gun
#		-Keirans angle thing?
#	7:bullet bounces?
#	8:bullet trails (particle effects?)
#
#	add more stuff if you think of it