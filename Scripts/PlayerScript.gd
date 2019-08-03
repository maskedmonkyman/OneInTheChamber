extends KinematicBody2D

var moveSpeed = 10_000;
var heldGun;
var parent;
var timer;
var pistol = preload("res://Scenes/Pistol.tscn")

func _ready():
	#parent is the TileMap and the script attached to it
	parent = get_parent()
	
	#-------------------------pistol test case
	heldGun = pistol.instance();
	self.add_child(heldGun);
	parent.gunsOnLevel += 1;
	#heldGun.position.x += 100
	timer = $Timer
	timer.connect("timeout", self, "CheckForLoss")
	heldGun.Equip(self)
	#print(heldGun);
	pass

func DropGun():
	heldGun.PlayerDrop();
	heldGun = null;
	parent.gunsOnLevel -= 1;
	if(parent.gunsOnLevel == 0):
		timer.set_wait_time(2)
		timer.start()

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
	#self.get_node("playerSprite").rotation = atan2(lookVec.y, lookVec.x)
