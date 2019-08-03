extends KinematicBody2D

var hitsLeft = 1;
var bulletSpeed = 750;

var velocity = Vector2()

func start(pos, dir):
    rotation = dir
    position = pos
    velocity = Vector2(bulletSpeed, 0).rotated(rotation)

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if(collision != null and collision.collider_shape.get_parent().name != "PlayerBody"):
		if collision.collider.has_method("hit"):
			collision.collider.hit()


func _on_BulletCol_body_entered():
	hitsLeft -= 1;
	if(hitsLeft == 0):
		print("hit");
		queue_free();