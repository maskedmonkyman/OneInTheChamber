extends KinematicBody2D

var moveSpeed = 10_000;
var heldGun;

var pistol = preload("res://Scenes/Pistol.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	heldGun = pistol.instance();
	print(heldGun);
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

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
			heldGun.Fire(lookVec);
	#self.get_node("playerSprite").rotation = atan2(lookVec.y, lookVec.x)
