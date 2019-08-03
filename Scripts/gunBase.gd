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
	queue_free()

func Equip(gunOwner):
	self.gunOwner = gunOwner
	var collider = self.get_node("CollisionShape2D")
	collider.free()