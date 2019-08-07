#-------------------------------- Editor --------------------------------
#tile base size is 32x32 pixels
#
#all scene nodes should be camelcase, this is to avoid name conflicts with node types in scripts
#
#collision layers:
#	layer 1: level
#	layer 2: player
#	layer 3: enemys
#	layer 4: guns
#
#------------------------------- Hierarchy ------------------------------
#all character bodies must have a kinematic body as thier base node
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
#-------------------------------- Script --------------------------------
#non constant variables and methods are camelCase
#
#constants are pascalcase
#
#if a function is more than 30 lines check to see if it can be broken down into smaller functions
#
#please atempt to give meaningful variable names and comment out code
#
#where posible try to give a one line comment after functions, if statments or variable
#modification/deleration
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
