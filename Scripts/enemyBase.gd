extends KinematicBody2D

#how close an agent can get to a path point in order to
#consider it reached
const distToPointTolerance = 2
#how short an agent is alowed to travel to start
#considering this path a failure
const pathFailTolerance = 0.05
const thrust = 5000
const agroRepathDist = 50
# how long an agent must wait to consider this path failed
const pathFailTime = 0.2
const debugLine : bool = true

enum State {Patrol, Chase}

var path = PoolVector2Array()
var currentBehavior = State.Patrol
var aimTarget : Vector2

onready var nav = find_parent("Navigation2D")
onready var player = nav.find_node("PlayerBody")
onready var homePoint = get_parent().position
onready var pathFailTimer = $"../pathFailTimer"
onready var fireTimer = $"../fireTimer"
onready var line = $"../Line2D"

#this is aweful but no time to refactor
onready var patrolRad = get_parent().patrolRad
onready var patrolAgroRadius = get_parent().patrolAgroRadius
onready var deAgroRadius = get_parent().deAgroRadius
onready var chaseDist = get_parent().chaseDist
onready var aimSpeed = get_parent().aimSpeed
onready var aimRange = get_parent().aimRange

func _ready():
	assert(nav)
	pathFailTimer.wait_time = pathFailTime
	pathFailTimer.connect("timeout", self, "failPath")
	fireTimer.wait_time = aimSpeed
	fireTimer.connect("timeout", self, "fire")
	if debugLine:
		line.global_position = Vector2(0,0)
		line.points.append(Vector2(0,0))
		line.points.append(Vector2(300,300))

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
		#do turn gun and stuff
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
			fireTimer.start()
			aimTarget = player.global_position
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
			
func fire():
	print("bang")

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
