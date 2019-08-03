extends KinematicBody2D

var beenFired;
var gunOwner

func _ready():
	beenFired = false;

func Drop():
	pass

func Equip(gunOwner):
	self.gunOwner = gunOwner
	var collider = self.get_node("CollisionShape2D")
	collider.free()