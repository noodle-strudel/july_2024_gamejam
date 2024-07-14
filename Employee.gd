extends Area2D
signal newTask(value)
signal taskComplete(value)

# Setup Var
var task
var goal
var taskActive = false
var taskRequested = true
var taskCompleted = true
var rng = RandomNumberGenerator.new()

# Check if player collides with Employee
func _on_body_entered(body):
	# See if task is requested from player and start
	if (taskActive == false && taskRequested == true):
		taskActive = true
		task = rng.randi_range(0, 10)
		emit_signal("newTask", task)
		print("Starting Task Number: ", task)
		return
	
	# Reset for task completion
	if (taskCompleted):
		taskActive = false
		taskRequested = true
		emit_signal("taskComplete", task)
		print("Task Completed")
		return
		
