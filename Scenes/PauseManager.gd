extends Node

var pausePopup 
var losePopup
var isPaused
var hasLost

# Called when the node enters the scene tree for the first time.
func _ready():
	pausePopup = $PausePopup
	losePopup = $LosePopup
	isPaused = false
	hasLost = false
	pass # Replace with function body.

func Lose():
	hasLost = true
	get_tree().paused = true
	losePopup.show()

func _physics_process(delta):
	if Input.is_action_just_pressed("Escape"):
		if(!hasLost):
			if(!isPaused):
				get_tree().paused = true
				isPaused = true;
				pausePopup.show();
			else:
				isPaused = false;
				get_tree().paused = false
				pausePopup.hide()
		else:
			get_tree().reload_current_scene()