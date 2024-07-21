extends CharacterBody2D
signal linkTask(value)
signal removeTask(value)
signal loseGame(value)
signal taskInList(value)

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
var activeTaskCount = 0
var tasksCompleted = 0
var requestedTasks = 0

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
	# Movement Calculation And Animation trigger
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
# GO TO THIS FUNCTION WHEN ADDING TASK INFORMATION
# ---------------------------------------------------------
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
	print("Request B4: ", requestedTasks)
	requestedTasks -= 1
	print("Request AFTER: ", requestedTasks)
	
	# Timer
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = fixTaskTimeLimit
	timer.timeout.connect(_timer_Timeout)
	
	# Specific Task Setup
	var newTask = Task.new()

	# -----------------------------------------------------------------------
	# If your making a new task put all the information in THIS match case.
	# If any task specific effects / value changes such as timer length change
	# In specific match case
	
	# If your task has any specific effects on completion put them in the
	# Match case in the "_on_employee_task_complete" function
	# -----------------------------------------------------------------------
	match value:
		1:
			newTask.taskName = "Get and Bring water"
			newTask.taskScore = 50
			timer.wait_time = 45
		2:
			newTask.taskName = "Fix Printer"
			newTask.taskScore = 100
		3:
			newTask.taskName = "Erase WhiteBoard"
			newTask.taskScore = 50
		4:
			newTask.taskName = "Water Plant"
			newTask.taskScore = 75
		5:
			newTask.taskName = "Microwave Lunch"
			newTask.taskScore = 100
			timer.wait_time = 45
			
					
	# Add task to list and finish setup
	newTask.timerObject = timer
	newTask.taskID = value
	tasks.append(newTask)
	ui.create_task(newTask.taskName, newTask.timerObject.wait_time, newTask.taskID)
	timer.start()
	taskCount += 1

# Find task to remove on completion and grant score
# --- Any Task Specific Completion effects go here ---
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
			
			tasksCompleted += 1
			score += i.taskScore

			ui.update_score(str(score))
			$"../TaskCompleted".play()
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
	if warnings >= 3:
		emit_signal("loseGame", score)
	print("Warnings: ", warnings)
	boss_play(warnings)

# If player doesnt claim task in time
func _on_employee_late_warning(value):
	for i in tasks:
		if (i.taskID == value):
			var index = tasks.find(i)
			ui.remove_task(tasks[index].taskID)
			tasks.remove_at(index)
			taskCount -= 1
	
	ui.add_warning(warnings)
	warnings += 1
	if warnings >= 3:
		emit_signal("loseGame", score)
	print("Warnings: ", warnings)
	boss_play(warnings)

func boss_play(warnings):
	var song1 = preload("res://SFX/voices/boss1.mp3")
	var song2 = preload("res://SFX/voices/boss2.mp3")
	var song3 = preload("res://SFX/voices/boss3.mp3")
	var song4 = preload("res://SFX/voices/boss4.mp3")
	var audio_player = $"../Boss"
	match warnings:
		1:
			audio_player.stream = song2
			audio_player.play()
		2:
			audio_player.stream = song4
			audio_player.play()
		3:
			audio_player.stream = song1
			audio_player.play()

# Check if taskObject's required task is active
func _on_checkTaskInList(value):
	for i in tasks:
		if (i.taskID == value):
			emit_signal("taskInList", value)
			return
			
	print("Object not in list")

# Progressive Task Chaos System
func taskIncrement():
	activeTaskCount = requestedTasks + len(tasks)
	if (len(tasks) >= totalTaskCount):
		emit_signal("linkTask", 0)
		requestedTasks -= 1
		return
	if (tasksCompleted < 6 && activeTaskCount >= 2):
		emit_signal("linkTask", 0)
		requestedTasks -= 1
		return
	elif (tasksCompleted < 10 && activeTaskCount >= 4):
		emit_signal("linkTask", 0)
		requestedTasks -= 1
		return
	elif (tasksCompleted < 14 && activeTaskCount >= 7):
		emit_signal("linkTask", 0)
		requestedTasks -= 1
		return
	elif (tasksCompleted < 20 && activeTaskCount >= 10):
		emit_signal("linkTask", 0)
		requestedTasks -= 1
		return
	
	requestedTasks += 1
