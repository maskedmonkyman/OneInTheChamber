extends KinematicBody2D
class_name GunBase

export var bullet = preload("res://scenes/weapons/bullets/BulletBase.tscn")

var playerFired : bool = false
var gunOwner = null

onready var sprite = $sprite
onready var collider = $collisionShape2D
onready var muzzlePoint = $muzzlePoint
onready var muzzleFlashSprite = $muzzlePoint/muzzleFlashSprite
onready var animPLayer = $animPlayer
onready var gunSoundStream = $muzzlePoint/gunSoundStream
onready var levelRoot = find_parent("navigation2D")

func _ready():
	assert(levelRoot) #make sure we are in a level

func fire(spawnAngle : float): #makes a new bullet instance, moves/rotates it and attaches it to the level
	var spawnedBullet = bullet.instance()
	spawnedBullet.global_position = muzzlePoint.global_position
	spawnedBullet.rotation = spawnAngle
	setBulletCollisionLayer(spawnedBullet)
	levelRoot.add_child(spawnedBullet)
	muzzleFlash()

func muzzleFlash():
	pass

func setBulletCollisionLayer(spawnedBullet : BulletBase):
	pass
	#if ()
	#set_collision_mask_bit(2, true)