extends KinematicBody2D
class_name BulletBase

export var numberOfPenatrations = 1;
export var bulletSpeed = 750;

var gunOwner
onready var velocity : Vector2 = Vector2(bulletSpeed, 0).rotated(rotation)

func _ready():
	pass

func _physics_process(delta): #will move bullet and check for collisions
	var collision = move_and_collide(velocity * delta)

	if(collision):
		hitSomething(collision)

func hitSomething(collision : KinematicCollision2D): #handle bullet hits and destruction
	numberOfPenatrations -= 1
	
	var otherBodie = collision.collider
	if (otherBodie.has_method("receiveHit")): #see if what we hit has a hit method
		otherBodie.receiveHit()
	if(numberOfPenatrations <= 0): #destroy this bullet if it has no more penatrations
		queue_free()