extends KinematicBody2D

var hitsLeft = 1;
var bulletSpeed = 750;

var gun
var gunOwner

var startPos = Vector2()
var velocity = Vector2()

var trailColor 
var trailWidth = 0.3

signal BulletHit

func _ready():
	pass

func Start(pos, dir, gun):
	
	rotation = dir
	position = pos
	startPos = pos
	
	velocity = Vector2(bulletSpeed, 0).rotated(rotation)
	#hitsLeft = pen
	
	trailColor = Color(255, 0, 0, 0.01)
	
	self.gun = gun
	gunOwner = gun.gunOwner
	print("gunowner: ", gunOwner)
	#gives bullet affiliation
	if (gunOwner.is_in_group("Player")):
		add_to_group("Player")
	else:
		add_to_group("Enemy")
		print ("setEnemy")
	
	
	#------------masks layer of owner----------
#	var pl = gunOwner.get_collision_layer()
#	print("pl",pl)
#	var sl = get_collision_mask()
#
#	self.set_collision_mask(sl-pl)
#	print("sl",self.get_collision_mask())
	
	#-------------fuck it---
	if is_in_group("Player"):
		set_collision_mask_bit(1, false)
	else:
		set_collision_mask_bit(2, false)
		
	print("bulletcol ", get_collision_mask())
	

func _draw():
	draw_line(Vector2(0, 0), startPos-global_position, trailColor, trailWidth, false )

func _process(delta):
	update()

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
