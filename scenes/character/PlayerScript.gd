extends KinematicBody2D
class_name Player

enum AnimState {Idle, Walk}

export var moveSpeed = 10_000;
export var health = 3
export var debugInfo : bool = false #just shows fps right now
export var spawnGun = preload("res://scenes/weapons/guns/Pistol.tscn") #the weapon the player will spawn with

var animState = AnimState.Idle
var moveDir : Vector2 = Vector2(0,0) #the direction the player will move per physics tick
var heldGun : GunBase = null #the weapon held by the player

onready var levelRoot = find_parent("navigation2D")
onready var animPlayer = $animationPlayer
onready var sprite = $playerSprite
onready var armPivot = $playerSprite/armPivot
onready var handLocation = $playerSprite/armPivot/handLocation
onready var gunPickupArea = $gunPickupArea
onready var label = $label

func _ready():
	assert(levelRoot) #make sure we are attatched to a level
	if(spawnGun):
		heldGun = spawnGun.instance()
		pickUpGun(heldGun)
	playIdleAnim()

func _process(delta): #handles input
	moveDir = Vector2(0,0) #handle updating move direction
	
	#input
	if Input.is_action_pressed("Player_Up"):
		moveDir.y -= 1
	if Input.is_action_pressed("Player_Down"):
		moveDir.y += 1
	if Input.is_action_pressed("Player_Left"):
		moveDir.x -= 1
	if Input.is_action_pressed("Player_Right"):
		moveDir.x += 1
	
	moveDir = moveDir.normalized()
	
	#handle weapon firing
	if (heldGun):
		if(Input.is_action_just_pressed("Player_Fire")):
			shootAndDropGun()
	else:
		checkForGun()
		
	if(debugInfo):
		updateDebugInfo()

func _physics_process(delta): #handles movement and animation
	handleAnim()
	move_and_slide(moveDir * moveSpeed * delta)

func handleAnim(): #sets anim, and rotates sprite(s)
	#walk/idle
	if(moveDir.length() > 0): # walk
		playWalkAnim()
	else: #idle
		playIdleAnim()
	
	#look direction
	var lookVec = get_global_mouse_position() - global_position #used to tell which way the player is looking
	
	if(lookVec.x > 0): #look left
		sprite.flip_h = false
	else: #look right
		sprite.flip_h = true
	
	armPivot.rotation = atan2(lookVec.y, lookVec.x)
	
	#weapon direction
	if heldGun:
		if(sprite.flip_h): #gun face left
			heldGun.scale.y = abs(heldGun.scale.y) * -1
		else: #gun face right
			heldGun.scale.y = abs(heldGun.scale.y)
	#todo trigonometry to correct the minor angle offset between the guns muzzle and the mouse 

func playIdleAnim():
	if(animState != AnimState.Idle):
		animState = AnimState.Idle
		animPlayer.play("Idle")

func playWalkAnim():
	if(animState != AnimState.Walk):
		animState = AnimState.Walk
		animPlayer.play("Walk")

func shootAndDropGun():
	heldGun.fire(armPivot.rotation) #shoot
	#do cleanup and reparent
	heldGun.playerFired = true
	heldGun.gunOwner = null
	handLocation.remove_child(heldGun)
	levelRoot.add_child(heldGun)
	heldGun.global_position = global_position
	heldGun.scale.y = abs(scale.y)
	heldGun = null
#todo fancy gun drop animation

func pickUpGun(gun : GunBase) -> bool: #tries to pick up gun and retruns the result of the pickup
	if (!gun.playerFired and !gun.gunOwner): # check to see if gun is on ground and not fired
		if (gun.get_parent()):
			gun.get_parent().remove_child(gun) #if the gun has a perent remove it
		heldGun = gun
		heldGun.gunOwner = self #give the gun to us
		handLocation.add_child(heldGun)
		heldGun.global_position = handLocation.global_position
		return true
	else: #if the gun was fired or belongs to someone else return false
		return false

func bulletHit():
	health -= 1

func checkForGun(): #looks for gun objects in the level and picks them up if not fired
	var otherBodies = gunPickupArea.get_overlapping_bodies()
	if (otherBodies.size() > 0): #check to see if we found some bodies
		for body in otherBodies: #check each body in the list
			if (body is GunBase): #check to see if the body is a gun
				if(pickUpGun(body)): #check to see if we can pick that gun up
					break #if we picked up the gun break out of the loop

func updateDebugInfo():
	label.text = "fps " + str(Engine.get_frames_per_second())
