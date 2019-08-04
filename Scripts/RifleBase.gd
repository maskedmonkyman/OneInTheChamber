extends "res://Scripts/GunBase.gd"

var tex = preload("res://Assets/Sprites/Weapons/Winchester.png")
#var mfTex = preload("res://Assets/Sprites/Effects/...

export var muzzleX = 10
export var muzzleY = 1.5

func GunSpefReady():
	#performance warning - dynamic texture loading
	sprite.set_texture(tex)
	var pos = Vector2(muzzleX, muzzleY)
	muzzle.set_position(pos)

func Fire(rot):
	SpawnBullet(rot, muzzle.global_position)
