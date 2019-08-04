extends KinematicBody2D

var hitsLeft = 1;
var bulletSpeed = 750;

var gun
var gunOwner

var velocity = Vector2()

signal BulletHit

func _ready():
	pass

func Start(pos, dir, gun):
	
	rotation = dir
	position = pos
	velocity = Vector2(bulletSpeed, 0).rotated(rotation)
	#hitsLeft = pen
	
	self.gun = gun
	gunOwner = gun.gunOwner
	#gives bullet affiliation
	if (gunOwner.is_in_group("Player")):
		add_to_group("Player")
	else:
		add_to_group("Enemy")
	
	
	#------------masks layer of owner----------
	var pl = gunOwner.get_collision_layer()
	#print(pl)
	self.set_collision_mask_bit(pl, true)
	#print(self.get_collision_mask_bit(pl))

func _physics_process(delta): #---------------------------------------------
	
	var collision = move_and_collide(velocity * delta)
	
	if(collision != null):
		var col = collision.collider
		
		if col.is_in_group("Actor"):
			self.connect("BulletHit", col, "OnBulletHit")
			
		var dealDamage = true
		if (col.is_in_group(get_groups()[0])):
			dealDamage = false
			print (dealDamage)
		emit_signal("BulletHit", dealDamage) #add any other metadata here
		
		hitsLeft -= 1;
		if(hitsLeft == 0):
			queue_free();
