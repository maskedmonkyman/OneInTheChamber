extends KinematicBody2D

var beenFired;
var gunOwner
var collider
var heldByPlayer
var gunType

var sprite
var muzzle

var bulletPrefab = preload("res://Scenes/Bullet.tscn")

func _ready():
	beenFired = false;
	#print("gunReady")
	collider = self.get_node("CollisionShape2D")
	var tileMap = find_parent("TileMap")
	tileMap.gunsOnLevel += 1;
	print("Gun made. Guns on level:", tileMap.gunsOnLevel);
	
	sprite = $Sprite
	muzzle = $Muzzle
	
	GunReady() #for each gun variant
	
func GunReady():
	pass

func EnemyDrop():
	var tileMap = self.find_parent("TileMap");
	var oldPos = global_position
	assert(tileMap)
	#print(tileMap.get_children())
	get_parent().remove_child(self)
	tileMap.add_child(self);
	global_position = oldPos
	collider.disabled = false;

func PlayerDrop():
	#do gunchuck here
	var tileMap = self.find_parent("TileMap");
	var oldPos = global_position
	assert(tileMap)
	#print(tileMap.get_children())
	get_parent().remove_child(self)
	tileMap.add_child(self);
	global_position = oldPos
	#self.set_owner(tileMap)

func Equip(gunOwner):
	self.gunOwner = gunOwner
	#gunOwner.PickUpGun(self);
	print(collider)
	if(collider != null):
		collider.disabled = true;

func Fire(ang):
	pass

func MFlash():
	var mf = $mfSprite
	$AnimationPlayer.play("MuzzleFlash")

func SpawnBullet(ang, pos): #pos must be Vector2
	var bullet = bulletPrefab.instance()
	bullet.Start(pos, ang, self)
	get_tree().get_root().add_child(bullet)