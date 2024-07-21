extends CharacterBody2D
signal linkTask(value)
signal removeTask(value)

# Var Init
@onready var ui := $"../CanvasLayer/GameUI"
@onready var animations = $AnimationPlayer

# Exported values for easy editing
@export var speed = 600.0
@export var accel = 5
@export var totalTaskCount = 3
@export var fixTaskTimeLimit = 20

var rng = RandomNumberGenerator.new()
var tasks : Array[Task] = []
var taskCount = 0
var input: Vector2
var score = 0
var warnings = 0

# Task Class Setup
class Task:
	var taskName = ""
	var timerObject : Timer
	var taskID : int
	var taskGoal : int
	var taskScore : int


# Movement Input
func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input.normalized()

#updates movement animation
func updateAnimation():
	if velocity.length() != 0:
		var direction = ""
		# Compare absolute values of x and y velocities
		if abs(velocity.x) > abs(velocity.y):
			# More horizontal movement
			if velocity.x < 0:
				direction = "left"
			else:
				direction = "right"
		else:
			# More vertical movement
			if velocity.y < 0:
				direction = "back"
			else:
				direction = "front"
		
		if direction != "":
			animations.play(direction + " walk")
	else:
		animations.play("idle")
# Apply Movement
func _process(delta):
	var playerInput = get_input()
	if playerInput == Vector2.ZERO:
		velocity = Vector2.ZERO
		$Walking.stop()
	else:
		velocity = lerp(velocity, playerInput * speed, delta * accel)
		if not $Walking.playing:
			$Walking.play()
	move_and_slide()
	updateAnimation()

# Setup Task upon Claim
func _on_employee_new_task():
	var value = rng.randi_range(1, totalTaskCount)
	
	# Duplicate Task Checking
	var taskInList = true
	while taskInList:
		taskInList = false
		for i in tasks:
			if (i.taskID == value):
				print("Duplicate found: ", value)
				value = rng.randi_range(1, totalTaskCount)
				print("New Value: ", value)
				taskInList = true
	
	emit_signal("linkTask", value)
	print("Task Number: ", value)
	
	# Timer
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = fixTaskTimeLimit
	timer.timeout.connect(_timer_Timeout)
	timer.start()
	
	# Specific Task Setup
	var newTask = Task.new()

	# If your making a new task put all the information in THIS match case.
	# If your task has any specific effects on completion put them in the
	# Match case in the "_on_employee_task_complete" function
	match value:
		1:
			newTask.taskName = "Get and Bring water"
			newTask.taskScore = 50
		2:
			newTask.taskName = "Fix Printer"
			newTask.taskScore = 100
		3:
			newTask.taskName = "Erase WhiteBoard"
		4:
			newTask.taskName = "Water Plant"
					
	# Add task to list and finish setup
	newTask.timerObject = timer
	newTask.taskID = value
	tasks.append(newTask)
	ui.create_task(newTask.taskName, newTask.timerObject.wait_time, newTask.taskID)
	taskCount += 1


# Find task to remove on completion and grant score
func _on_employee_task_complete(value):
	for i in tasks:
		if (i.taskID == value):
			# General effects for task completion go here
			# If there are any task specific completion effect put them inside respective match case
			match value:
				1:
					pass
				2:
					pass
				3:
					pass
					
			score += i.taskScore
			ui.update_score(str(score))
			
			var index = tasks.find(i)
			ui.remove_task(tasks[index].taskID)
			tasks[index].timerObject.queue_free()
			tasks.remove_at(index)
			taskCount -= 1

# Timer End remove from list and give warning
func _timer_Timeout():
	for i in tasks:
		if (i.timerObject.time_left <= 0):
			var index = tasks.find(i)
			ui.remove_task(tasks[index].taskID)
			tasks.remove_at(index)
			taskCount -= 1
			print("Timeout time left: ", i.timerObject.time_left, " ID ", i.taskID)
			emit_signal("removeTask", i.taskID)
	
	ui.add_warning(warnings)
	warnings += 1
	print("Warnings: ", warnings)

# If player doesnt claim task in time
func _on_employee_late_warning(value):
	for i in tasks:
		if (i.taskID == value):
			var index = tasks.find(i)
			ui.remove_task(tasks[index].taskID)
			tasks.remove_at(index)
			taskCount -= 1
	warnings += 1
	print("Warnings: ", warnings)
