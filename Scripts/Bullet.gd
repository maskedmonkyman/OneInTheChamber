extends KinematicBody2D

var hitsLeft = 1;
var bulletSpeed = 750;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func start(pos, dir):
    rotation = dir
    position = pos
    velocity = Vector2(speed, 0).rotated(rotation)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_BulletCol_body_entered():
	hitsLeft -= 1;
	if(hitsLeft == 0):
		print("hit");
		queue_free();