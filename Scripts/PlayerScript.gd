extends KinematicBody2D

var moveSpeed = 10_000;
var heldGun;
var parent;
var timer;
var pistol = preload("res://Scenes/Pistol.tscn")
onready var area = $Area2D

func _ready():
	#parent is the TileMap and the script attached to it
	parent = get_parent()
	
	#-------------------------pistol test case
	heldGun = pistol.instance();
	PickUpGun(heldGun)
	heldGun.Equip(self)
	#parent.gunsOnLevel += 1;
	#heldGun.position.x += 100
	timer = $Timer
	timer.connect("timeout", self, "CheckForLoss")
	#print(heldGun);
	pass

func DropGun():
	heldGun.PlayerDrop();
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
	
	moveVec = moveVec.normalized()
	move_and_slide(moveVec * moveSpeed * delta) 
	
	var lookVec = get_global_mouse_position() - global_position
	global_rotation = atan2(lookVec.y, lookVec.x)
	
	if(heldGun != null):
		if Input.is_action_just_pressed("Player_Fire"):
			heldGun.Fire(global_rotation);
			DropGun();
	else:
		CheckForGun();

func CheckForGun():
	var otherAreas = area.get_overlapping_bodies()
	if (otherAreas.size() > 1):
		for otherArea in otherAreas:
			if(otherArea != self): 
				if(otherArea.has_method("Equip")):  #only guns have Equip methods
					#print("blah")
					var gun
					if("Pistol" in otherArea.gunType):
						otherArea.free()
						gun = pistol.instance()
					parent.gunsOnLevel -= 1;
					PickUpGun(gun)
					heldGun.Equip(self)
				pass
	#self.get_node("playerSprite").rotation = atan2(lookVec.y, lookVec.x)
