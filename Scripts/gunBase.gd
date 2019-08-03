extends KinematicBody2D

var beenFired;
var gunOwner

func _ready():
	beenFired = false;

func EnemyDrop():
	print ("drop")
	#get_parent().get_parent().add_child(self)
	#print (get_parent())


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
	
	#queue_free()

func Equip(gunOwner):
	self.gunOwner = gunOwner
	var collider = self.get_node("CollisionShape2D")
	collider.free()