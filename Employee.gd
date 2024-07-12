extends Area2D

var taskActive = false
var taskRequested = true
var taskCompleted = true
var rng = RandomNumberGenerator.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if (taskActive == false && taskRequested == true):
		taskActive = true
		var task = rng.randi_range(0, 10)
		print("Starting Task Number: ", task)
		return

	if (taskCompleted):
		taskActive = false
		taskRequested = true
		print("Task Completed")
		return
		
