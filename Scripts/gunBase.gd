extends KinematicBody2D

var beenFired;

# Called when the node enters the scene tree for the first time.
func _ready():
	beenFired = false;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func Drop():
	pass

func Equip():
	var collider = self.get_node("CollisionShape2D")
	collider.free()