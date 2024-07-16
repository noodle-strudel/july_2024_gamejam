extends Area2D
signal newTask
signal taskComplete(value)

# Setup Var
var task = 0
var goal
var taskActive = false
var taskRequested = true
var taskCompleted = false
var localTaskID = 0
var rng = RandomNumberGenerator.new()

# Check if player collides with Employee
func _on_body_entered(body):
	# See if task is requested from player and start
	if (taskActive == false && taskRequested == true):
		taskActive = true
		emit_signal("newTask")
		return
	
	# Reset for task completion
	if (taskCompleted):
		emit_signal("taskComplete", task)
		taskActive = false
		taskRequested = true
		task = 0
		print("Task Completed")
		taskCompleted = false
		return
	else:
		print("Not Complete")
		
func _on_player_link_task(value):
	if (task == 0 && taskActive == true):
		task = value

func _on_player_remove_task(value):
	if (task == value):
		task = 0
		taskActive = false

func _on_player_task_finished(value):
	taskCompleted = true

func _on_task_goal_complete(value):
	if (value == task):
		taskCompleted = true
		
func _on_task_remote_complete(value):
	if (value == task):
		emit_signal("taskComplete", task)
		taskActive = false
		taskRequested = true
		print("Task Completed")
		taskCompleted = false
		task = 0
