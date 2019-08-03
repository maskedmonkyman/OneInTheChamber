extends KinematicBody2D

onready var nav = self.find_parent("Navigation2D")
onready var area = $Area2D
var path = PoolVector2Array()
const thrust = 5000
#how close an agent can get to a path point in order to
#consider it reached
const distTolerance = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	assert(nav)
	
func _input(event):
	if Input.is_action_just_pressed("Player_Fire"):
		print(event.global_position)
		findPath(event.global_position)
	
func _physics_process(delta):
	#if the path is empty turn of physics process
	if(path.size() <= 0):
		set_physics_process(false)
		return

	var dir = path[0] - position; #get point direction
	var otherAreas = area.get_overlapping_bodies()
	#if (otherAreas.size() > 1):
	#	for otherArea in otherAreas:
	#		if(otherArea != self):
				#for identifiying things around the agent
	
	dir = dir.normalized();
	move_and_slide(dir * thrust * delta) #move toward it
	if(position.distance_to(path[0]) < distTolerance):
		path.remove(0) #if we are close to point remove it

func findPath(destination):
	path = nav.get_simple_path(position, destination, false)
	set_physics_process(true)