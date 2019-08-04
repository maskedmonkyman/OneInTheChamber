extends KinematicBody2D

var beenFired;
var gunOwner
var collider
var heldByPlayer
var gunType

func _ready():
	beenFired = false;
	#print("gunReady")
	collider = self.get_node("CollisionShape2D")
	var tileMap = find_parent("TileMap")
	tileMap.gunsOnLevel += 1;
	print("Gun made. Guns on level:", tileMap.gunsOnLevel);

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