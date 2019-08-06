extends Position2D

export var patrolRad = 100
export var patrolAgroRadius = 200;
export var deAgroRadius = 300;
export var chaseDist = 200;
export var aimSpeed = 0.5;
export var aimRange = 100;
export var moveForce = 6000;
export var debugLine : bool = false
export var gunType = preload("res://Scenes/Pistol.tscn")
export var big : bool = false