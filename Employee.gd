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
var reset = false
var rng = RandomNumberGenerator.new()

var timer : Timer = Timer.new()

# Editor Variables for easier changing
@export var claimTaskTime = 20
@export var minTaskAppearTime = 5
@export var maxTaskAppearTime = 20

@onready var notif = $"notification"

# Employee Timer and Signal Setup
func _ready():
	# Timer Setup
	add_child(timer)
	timer.one_shot = true
	timer.autostart = false
	timer.timeout.connect(_timer_Timeout)
	
	# Connect Employees to Player
	%Player.linkTask.connect(_on_player_link_task)
	%Player.removeTask.connect(_on_player_remove_task)
	
	# Connect Objects to Employees
	for object in get_tree().get_nodes_in_group("TaskObjects"):
		object.taskGoalComplete.connect(_on_task_goal_complete)
		object.taskRemoteComplete.connect(_on_task_remote_complete)
		
# Timer Start / Restart
func _process(delta):
	if (taskRequested == false && timerStarted == false):
		timer.start(rng.randi_range(minTaskAppearTime, maxTaskAppearTime))
		timerStarted = true
	if timer.time_left < 10 && taskRequested:
		$"../Music".pitch_scale = 1.5
		var pitch_shift = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
		pitch_shift.pitch_scale = 1/1.5	
	
# Run if player collides with employee
func _on_body_entered(body):
	# See if task is requested from player and start
	if (taskActive == false && taskRequested == true):
		notif.hide()
		taskActive = true
		emit_signal("newTask")
		
		#Randomize sounds of employee
		var song1 = preload("res://SFX/voices/employee1.mp3")
		var song2 = preload("res://SFX/voices/employee2.mp3")
		var song3 = preload("res://SFX/voices/employee3.mp3")
		var song4 = preload("res://SFX/voices/employee4.mp3")
		var songs = [song1, song2, song3, song4]
		var random_index = randi() % songs.size()
		var random_number = randi() % 4 + 1
		play_song(songs[random_index])
		return
		
	# Reset for task completion
	if (taskCompleted):
		$"../TaskCompleted".play()
		emit_signal("taskComplete", task)
		taskActive = false
		taskRequested = false
		task = 0
		taskCompleted = false
		reset = false
		print("Task Completed")
		
		#Reset music speed to normal
		$"../Music".pitch_scale = 1
		var pitch_shift = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
		pitch_shift.pitch_scale = 1
		return
		
	# Debug Purposes
	elif (taskActive):
		print("Not Complete")
	elif (!taskRequested):
		print("No Task Yet")

func play_song(song):
	var audio_player = $VoiceFX
	audio_player.stream = song
	audio_player.play()

# After starting task get corrected value and set internally
func _on_player_link_task(value):
	if (value == 0 && taskRequested == false):
		print(self)
		reset = true
		return
	if (task == 0 && taskActive == true):
		task = value

# Task Failing remove from Employee
func _on_player_remove_task(value):
	if (task == value):
		task = 0
		taskActive = false
		taskCompleted = false
		taskRequested = false
		reset = false
		notif.hide()
		
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
	# Request taks from player and start warning timer
	reset = false
	if (!taskRequested):
		%Player.taskIncrement()
		if (reset):
			timerStarted = false
			_on_player_remove_task(task)
			return
	
		notif.show()
		taskRequested = true
		timerStarted = false
		timer.start(claimTaskTime)
		return
		print("Starting warning timer")
	# Submit warning if task unclaimed
	if (taskRequested):
		notif.hide()
	if (taskRequested == true && taskActive == false):
		emit_signal("lateWarning", task)
		_on_player_remove_task(task)	
		return
