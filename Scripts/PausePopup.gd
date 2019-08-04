extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.

func _process(delta):
	if Input.is_action_just_pressed("Escape"):
		if(!get_tree().paused):
			get_tree().paused = true
			self.show()
		else:
			get_tree().paused = false
			self.hide()