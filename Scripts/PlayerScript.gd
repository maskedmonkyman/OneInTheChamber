extends KinematicBody2D

var moveSpeed = 10_000;
var heldGun;
var parent;

var pistol = preload("res://Scenes/Pistol.tscn")

func _ready():
	
	parent = get_parent()
	
	#-------------------------pistol test case
	heldGun = pistol.instance();
	self.add_child(heldGun);
	#heldGun.position.x += 100
	
	heldGun.Equip(self)
	#print(heldGun);
	pass

func _process(delta):
	pass

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
	#self.get_node("playerSprite").rotation = atan2(lookVec.y, lookVec.x)
