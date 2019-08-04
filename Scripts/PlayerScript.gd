extends KinematicBody2D

var moveSpeed = 10_000;
var heldGun;
var parent;
var timer;

var pistol = preload("res://Scenes/Pistol.tscn")
var rifle = preload("res://Scenes/Rifle.tscn")
var shotgun = preload("res://Scenes/Shotgun.tscn")

onready var area = $gunDetectionArea
var animState;
var animPlayer;
var facingRight;

export var health = 3

func _ready():
	#parent is the TileMap and the script attached to it
	parent = get_parent()
	animPlayer = get_node("AnimationPlayer")
	PlayIdleAnim()
	facingRight = true;
	#-------------------------pistol test case
	#heldGun = pistol.instance();
	#PickUpGun(heldGun)
	#heldGun.Equip(self)
	#parent.gunsOnLevel += 1;
	#heldGun.position.x += 100
	timer = $Timer
	timer.connect("timeout", self, "CheckForLoss")
	#print(heldGun);
	pass

func PlayIdleAnim():
	if(animState != "Idle"):
		animState = "Idle"
		animPlayer.play("Idle")

func PlayWalkAnim():
	if(animState != "Walk"):
		animState = "Walk"
		animPlayer.play("Walk")

func DropGun():
	heldGun.queue_free()
	heldGun = null;
	parent.gunsOnLevel -= 1;
	print("Gun dropped. Guns on level:", parent.gunsOnLevel);
	if(parent.gunsOnLevel == 0):
		timer.set_wait_time(2)
		timer.start()

func PickUpGun(gun):
	print (gun.get_class())
	#if(gun.typeOf()):
	#	print("pistol")
	heldGun = gun;
	self.add_child(gun);

func CheckForLoss():
	print ("checking for loss")
	if(parent.gunsOnLevel == 0):
		print ("game lost")
		pass
	timer.stop();

func LookLeft():
	if(facingRight):
		facingRight = false;
		$playerSprite.flip_h = true;

func LookRight():
	if(!facingRight):
		facingRight = true;
		$playerSprite.flip_h = false;

func BulletHit():
		--health

func _physics_process(delta):
	# the directional vector the player will end up moving in
	var moveVec = Vector2()
	
	if Input.is_action_pressed("Player_Up"):
		moveVec.y -= 1
	if Input.is_action_pressed("Player_Down"):
		moveVec.y += 1
	if Input.is_action_pressed("Player_Left"):
		moveVec.x -= 1
	if Input.is_action_pressed("Player_Right"):
		moveVec.x += 1
	#if Input.is_action_just_pressed("Escape"):
		#if(!get_tree().paused):
		#	get_tree().paused = true
		#else:
		#	get_tree().paused = false
	
	moveVec = moveVec.normalized()
	if(moveVec.x != 0 or moveVec.y != 0):
		PlayWalkAnim()
	else:
		PlayIdleAnim()
		
	move_and_slide(moveVec * moveSpeed * delta) 
	
	var lookVec = get_global_mouse_position() - global_position
	if(lookVec.x < 0):
		LookLeft()
	else:
		LookRight()
	#global_rotation = atan2(lookVec.y, lookVec.x)
	
	#gun control--------------------------------------------
	if(heldGun != null):
		heldGun.rotation = atan2(lookVec.y, lookVec.x)
		
		if facingRight: 
			heldGun.sprite.flip_v = false
		else:
			heldGun.sprite.flip_v = true
		
		#must be last, destroys gun
		if Input.is_action_just_pressed("Player_Fire"):
			heldGun.Fire(global_rotation);
			DropGun();
		
	else:
		CheckForGun();
		
	#------------------------------------death/dying-----------------
	
	if (health == 0):
		parent.get_node("PauseManager").Lose()
	
	#----------------------------------------------------------

func CheckForGun():
	var otherAreas = area.get_overlapping_bodies()
	if (otherAreas.size() > 1):
		for otherArea in otherAreas:
			if (otherArea != self): 
			
				#if (otherArea.has_method("Equip")):  #only guns have Equip methods
				if (otherArea.is_in_group("Gun") && otherArea.gunOwner == null):
					var gun
					
					if ("Pistol" in otherArea.gunType):
						otherArea.free()
						gun = pistol.instance()
						
					elif ("Rifle" in otherArea.gunType):
						otherArea.free()
						gun = rifle.instance()
						
					elif ("Shotgun" in otherArea.gunType):
						otherArea.free()
						gun = shotgun.instance()
						print("shotgun")
						
					parent.gunsOnLevel -= 1;
					PickUpGun(gun)
					heldGun.Equip(self)
				pass
#	#self.get_node("playerSprite").rotation = atan2(lookVec.y, lookVec.x)

