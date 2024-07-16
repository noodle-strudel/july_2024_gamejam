extends CharacterBody2D
signal linkTask(value)
signal removeTask(value)
signal taskFinished(value)

# Var Init
var speed = 600.0
var accel = 5
var rng = RandomNumberGenerator.new()
var tasks : Array[Task] = []
var taskCount = 0
var input: Vector2
var score = 0

# Task Class Setup
class Task:
	var taskName = ""
	var timerObject : Timer
	var taskID : int
	var taskGoal : int

# Movement Input
func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input.normalized()

# Apply Movement
func _process(delta):
	var playerInput = get_input()
	velocity = lerp(velocity, playerInput * speed, delta * accel)
	move_and_slide()
			

# Setup Task upon Claim
func _on_employee_new_task():
	var value = rng.randi_range(1, 3)
	print("Original Number: ", value)
	
	# Duplicate Task Checking
	var taskInList = true
	while taskInList:
		taskInList = false
		for i in tasks:
			if (i.taskID == value):
				print("Duplicate found: ", value)
				value = rng.randi_range(1, 3)
				print("New Value: ", value)
				taskInList = true
	
	emit_signal("linkTask", value)
	print("Task Number: ", value)
	
	# Timer
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = 20.0
	timer.timeout.connect(_timer_Timeout)
	timer.start()
	
	# Specific Task Setup
	var newTask = Task.new()
	match value:
		1:
			newTask.taskName = "Get and Bring water"
		2:
			newTask.taskName = "Fix Printer"
		3:
			get_tree().call_group("Employees", "_on_task_goal_complete", 3)
					
	
	newTask.timerObject = timer
	newTask.taskID = value
	tasks.append(newTask)
	taskCount += 1
	
	for i in tasks:
		print("Array Task Name: ", i.taskName)
		print("Array Task ID: ", i.taskID)

# Find task to remove on completion
func _on_employee_task_complete(value):
	for i in tasks:
		if (i.taskID == value):
			match value:
				1:
					score += 10
				2:
					score += 100
				3: 
					score += 50
			var index = tasks.find(i)
			tasks.remove_at(index)
			taskCount -= 1

func _timer_Timeout():
	for i in tasks:
		if (i.timerObject.time_left <= 0):
			var index = tasks.find(i)
			tasks.remove_at(index)
			taskCount -= 1
			print("Timeout time left: ", i.timerObject.time_left, " ID ", i.taskID)
			emit_signal("removeTask", i.taskID)
