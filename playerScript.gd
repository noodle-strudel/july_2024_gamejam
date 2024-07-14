extends CharacterBody2D

# Var Init
var speed = 600.0
var accel = 5
var rng = RandomNumberGenerator.new()
var tasks : Array[Task] = []
var taskCount = 0
var input: Vector2

# Task Class Setup
class Task:
	var desc : String
	var timeRemaining : Timer
	var complete : bool
	var taskID : int
	var taskGoal : int
	
# Testing
func _ready():
	get_tree().call_group("Employees", "on_employee_new_task")	

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
func _on_employee_new_task(value):
	# Timer Setup
	var timer : Timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.autostart = true
	timer.wait_time = 5.0
	timer.timeout.connect(_timer_Timeout)
	timer.start()
	
	# Task Setup
	var newTask = Task.new()
	newTask.desc = "desc"
	newTask.timeRemaining = timer
	newTask.taskID = value
	tasks.append(newTask)
	++taskCount
	print(tasks)

# Find task to remove on completion
func _on_employee_task_complete(value):
	for i in tasks:
		print(i.taskID)
		if (i.taskID == value):
			var index = tasks.find(i)
			tasks.remove_at(index)
			print("Removed ", i, " at index ", index)

func _timer_Timeout():
	for i in tasks:
		if (i.timeRemaining.time_left <= 0):
			var index = tasks.find(i)
			tasks.remove_at(index)
			print("Timeout time left: ", i.timeRemaining.time_left, " ID ", i.taskID)
# Repeat code for additonal employees need to find way to combine signals
func _on_employee_2_new_task(value):
	_on_employee_new_task(value)


func _on_employee_2_task_complete(value):
	_on_employee_task_complete(value)
