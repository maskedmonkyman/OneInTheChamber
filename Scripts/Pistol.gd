extends "res://Scripts/GunBase.gd"

var tex = preload("res://Assets/Sprites/Weapons/Makarov.png")
#var mfTex = preload("res://Assets/Sprites/Effects/...

export var muzzleX = 10
export var muzzleY = 1.5
export var pens = 2

func GunReady():
	#performance warning - dynamic texture loading
	sprite.set_texture(tex)
	var pos = Vector2(muzzleX, muzzleY)
	muzzle.set_position(pos)
	gunType = "Pistol"

func Fire(rot):
	SpawnBullet(rotation, muzzle.global_position)