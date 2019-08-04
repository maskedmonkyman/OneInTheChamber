extends "res://Scripts/GunBase.gd"

var tex = preload("res://Assets/Sprites/Weapons/UTS.png")
#var mfTex = preload("res://Assets/Sprites/Effects/...

export var muzzleX = 10
export var muzzleY = 1.5
export var pens = 0
var numShots = 3
export var spread = 0.2

func GunReady():
	#performance warning - dynamic texture loading
	sprite.set_texture(tex)
	var pos = Vector2(muzzleX, muzzleY)
	muzzle.set_position(pos)
	gunType = "Shotgun"

func Fire(rot):
	SpawnBullet(rotation - spread, muzzle.global_position)
	SpawnBullet(rotation, muzzle.global_position)
	SpawnBullet(rotation + spread, muzzle.global_position)
#	var i = 0
#	while (i < numShots): 
#		var devi = rand_range(-spread, spread)
#		SpawnBullet(rotation + devi, muzzle.global_position)
#		++i
