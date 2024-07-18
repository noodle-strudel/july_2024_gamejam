extends Area2D
signal newTask
signal taskComplete(value)
signal lateWarning(value)

# Setup Var
var task = 0
var taskActive = false
var taskRequested = false
var taskCompleted = false
var timerStarted = false
var rng = RandomNumberGenerator.new()

var timer : Timer = Timer.new()

# Editor Variables for easier changing
@export var claimTaskTime = 20
@export var minTaskAppearTime = 5
@export var maxTaskAppearTime = 20

func _ready():
	# Timer Setup
	add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	timer.timeout.connect(_timer_Timeout)
	
func _process(delta):
	# Timer Start / Restart
	if (taskRequested == false && timerStarted == false):
		timer.start(rng.randi_range(minTaskAppearTime, maxTaskAppearTime))
		print(timer.wait_time)
		timerStarted = true
		
# Run if player collides with employee
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
		taskRequested = false
		task = 0
		print("Task Completed")
		taskCompleted = false
		return
	# Debug Purposes
	elif (taskActive):
		print("Not Complete")
	elif (!taskRequested):
		print("No Task Yet")

# After starting task get corrected value and set internally
func _on_player_link_task(value):
	if (task == 0 && taskActive == true):
		task = value

# Task Failing remove from Employee
func _on_player_remove_task(value):
	if (task == value):
		task = 0
		taskActive = false
		taskCompleted = false
		taskRequested = false
		
# Call when goal is complete but need to return to Employee
func _on_task_goal_complete(value):
	if (value == task):
		taskCompleted = true
		
		
# Call when task is completed away from employee
func _on_task_remote_complete(value):
	if (value == task):
		emit_signal("taskComplete", task)
		taskActive = false
		taskRequested = false
		print("Task Completed")
		taskCompleted = false
		task = 0
	
# Timer run out request new task
func _timer_Timeout():
	print("Timer Finished")
	# Request taks from player and start warning timer
	if (!taskRequested):
		taskRequested = true
		timerStarted = false
		timer.start(claimTaskTime)
		print("Starting warning timer")
		return
	
	# Submit warning if task unclaimed
	if (taskRequested):
		emit_signal("lateWarning", task)
		_on_player_remove_task(task)	
		return
