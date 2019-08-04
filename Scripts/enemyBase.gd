extends KinematicBody2D

const Pistol = preload("res://Scenes/Pistol.tscn")
#how close an agent can get to a path point in order to
#consider it reached
const distToPointTolerance = 2
#how short an agent is alowed to travel to start
#considering this path a failure
const pathFailTolerance = 0.05
const agroRepathDist = 50
# how long an agent must wait to consider this path failed
const pathFailTime = 0.2

enum State {Patrol, Chase}
enum AnimState {Walk, Idle}

var animState
var path = PoolVector2Array()
var currentBehavior = State.Patrol
var aimTarget : Vector2
var heldGun
export var health = 1

onready var nav = find_parent("Navigation2D")
onready var player = nav.find_node("PlayerBody")
onready var homePoint = get_parent().position
onready var pathFailTimer = $"../pathFailTimer"
onready var fireTimer = $"../fireTimer"
onready var line = $"../Line2D"
onready var animPlayer = $"AnimationPlayer"
onready var gunPivot = $"gunPivot"
onready var aimLine = $"aimLine"

#this is awful but no time to refactor
onready var patrolRad = get_parent().patrolRad
onready var patrolAgroRadius = get_parent().patrolAgroRadius
onready var deAgroRadius = get_parent().deAgroRadius
onready var chaseDist = get_parent().chaseDist
onready var aimSpeed = get_parent().aimSpeed
onready var aimRange = get_parent().aimRange
onready var thrust = get_parent().moveForce
onready var debugLine : bool = get_parent().debugLine
onready var gunType = get_parent().gunType
onready var big : bool = get_parent().big

func _ready():
	assert(nav)
	pathFailTimer.wait_time = pathFailTime
	pathFailTimer.connect("timeout", self, "failPath")
	fireTimer.wait_time = aimSpeed
	fireTimer.connect("timeout", self, "fire")
	giveGun()
	PlayWalkAnim()
	if debugLine:
		line.global_position = Vector2(0,0)
	find_parent("TileMap").enemiesOnLevel += 1

func giveGun(): #will be used to equip different guns to agents
	#do some gun rng
	heldGun = gunType.instance()
	find_parent("TileMap").gunsOnLevel -= 1
	heldGun.Equip(self)
	gunPivot.add_child(heldGun)
	
func _process(delta):
	update()

func _draw():
	if debugLine:
		#agroRad
		drawCircle(Vector2(0,0), deAgroRadius, Color(255,255,255))
		#aimDist
		drawCircle(Vector2(0,0), aimRange, Color(255,0,0))
		#patrolAgroRadius
		drawCircle(Vector2(0,0), patrolAgroRadius, Color(0,0,255))
		#homePointPatrolRad
		drawCircle(homePoint-global_position, patrolRad, Color(255,255,0))
	
func drawCircle(center : Vector2, radius, color):
	var segments = 32
	var angChange = 360/segments
	var ang = 0;
	for i in range(segments + 1):
		var point1 = Vector2(
			(cos(deg2rad(ang)) * radius) + center.x,
			(sin(deg2rad(ang)) * radius) + center.y)
		var point2 = Vector2(
			(cos(deg2rad(ang + angChange)) * radius) + center.x,
			(sin(deg2rad(ang + angChange)) * radius) + center.y)
		draw_line(point1, point2, color)
		ang += angChange

func _physics_process(delta):
	if !fireTimer.is_stopped():
		heldGun.look_at(aimTarget)
		return
	
	if (currentBehavior == State.Patrol):
		#look for player
		if (playerDist() < patrolAgroRadius):
			currentBehavior = State.Chase
			findPathToPoint(player.global_position)
		#follow path
		elif (path.size() > 0):
			followPath(delta)
		#repath
		else:
			findPathInPatrolRadius()
	if (currentBehavior == State.Chase):
		#shoot
		if (playerDist() < aimRange):
			aimTarget = player.global_position
			setAimLine()
			fireTimer.start()
		#repath player
		elif (playerDistToPoint(path[path.size()-1]) > agroRepathDist):
			findPathToPoint(player.global_position)
			followPath(delta)
		#deAgro
		elif(playerDist() > deAgroRadius):
			currentBehavior = State.Patrol
			findPathInPatrolRadius()
		#follow path
		elif (path.size() > 0):
			followPath(delta)
		#find new path if we some how ran out of points
		else:
			findPathToPoint(player.global_position)

func setAimLine():
	aimLine.global_position = Vector2(0,0)
	aimLine.add_point(global_position)
	aimLine.add_point(aimTarget)

func PlayWalkAnim():
	if(animState != AnimState.Walk):
		animState = AnimState.Walk
		animPlayer.play("Walk")

func PlayIdleAnim():
	if(animState != AnimState.Idle):
		animState = AnimState.Idle
		animPlayer.play("Idle")
		
func fire():
	heldGun.Fire(0)
	aimLine.clear_points()
	
func BulletHit():
	print("hit")
	health -= 1
	if(health == 0):
		get_parent().queue_free()
		heldGun.EnemyDrop()
		print("kill") 
		find_parent("TileMap").enemiesOnLevel -= 1
		print(find_parent("TileMap").enemiesOnLevel)
		get_parent().queue_free()
	

func followPath(delta):
	var dir = path[0] - global_position; #get point direction
	dir = dir.normalized();
	var oldPos = global_position #store current pos
	move_and_slide(dir * thrust * delta) #move toward it
	#used to check if we actually moved
	var deltaMove = global_position.distance_to(oldPos)
	if(deltaMove < pathFailTolerance and pathFailTimer.is_stopped()):
		pathFailTimer.start() #if we fail to move start the path fail timer
	elif(deltaMove > pathFailTolerance):
		pathFailTimer.stop() #if we manage to move stop the timer
		
	if(global_position.distance_to(path[0]) < distToPointTolerance):
		path.remove(0) #if we are close to point remove it

func findRandomPointInRadius(radiusCenter, radius):
	var point = Vector2(1,0);
	var ang = rand_range(0, 360)
	var dist = rand_range(0, radius)
	point = point.rotated(deg2rad(ang));
	point = point * dist
	return point + radiusCenter

func playerDistToPoint(point):
	return player.global_position.distance_to(point)

func playerDist():
	return global_position.distance_to(player.global_position)

func findPathInPatrolRadius():
	path = nav.get_simple_path(global_position,
		findRandomPointInRadius(homePoint, patrolRad),
		false)
	if debugLine:
		line.points = path

func findPathToPoint(destination):
	path = nav.get_simple_path(global_position, destination, false)
	if debugLine:
		line.points = path

func failPath():
	if (currentBehavior == State.Patrol):
		findPathInPatrolRadius()
	else:
		findPathToPoint(player.global_position)
