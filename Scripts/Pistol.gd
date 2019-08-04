extends "res://Scripts/gunBase.gd"

var bulletPrefab = preload("res://Scenes/Bullet.tscn")
var muzzle

func _ready():
	muzzle = $Muzzle
	gunType = "Pistol"

func _process(delta):
	pass

func Fire(ang):
	var bullet = bulletPrefab.instance()
	#print(bullet)
	#print($Muzzle)
	bullet.Start(muzzle.global_position, ang, self)
	get_tree().get_root().add_child(bullet)