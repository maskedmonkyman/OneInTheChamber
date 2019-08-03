extends "res://Scripts/gunBase.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var bulletPrefab = preload("res://Scenes/Bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func Fire(dir):
	var bullet = bulletPrefab.instance()