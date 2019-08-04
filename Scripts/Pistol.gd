extends "res://Scripts/GunBase.gd"

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