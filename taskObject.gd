extends Area2D
signal taskGoalComplete(value)
signal taskRemoteComplete(value)

@onready var plant_timer = $"../Plant/PlantTimer"
@onready var microwave_timer = $"../Microwave/MicrowaveTimer"
@onready var plant_control = $"../Plant/PlantControl"
@onready var plant_progress = $"../Plant/PlantControl/ProgressBar"
@export var objectTaskID = 0

var player : Node
var microwaveStarted = false
var microwaveReady = false

# Connect Signals
func _ready():
	%Player.taskInList.connect(_on_task_in_list)

# Plant progress bar update
func _physics_process(delta):
	plant_progress.value = -plant_timer.time_left

# Tell Player to check if task is in list
func _on_body_entered(body):
	%Player._on_checkTaskInList(objectTaskID)

# --------------------------------------------
# Trigger TaskObject Effects 
# IF YOUR ADDING A TASK GO TO THIS FUNCTION
# --------------------------------------------
func _on_task_in_list(value):
	if (objectTaskID == value):
		match objectTaskID:
			1: # Cooler Task
				get_tree().call_group("Employees", "_on_task_goal_complete", objectTaskID)
				print("Bring back water")
			2: # Printer Task
				get_tree().call_group("Employees", "_on_task_remote_complete", objectTaskID)
				print("Printer Fixed")
			3: # Whiteboard Task
				get_tree().call_group("Employees", "_on_task_remote_complete", objectTaskID)
				print("Erased Whiteboard")
			4: # Water Plant
				plant_timer.start()
				plant_control.show()
				print("Watering Plant...")
			5: # Microwave
				if (microwaveStarted == false && microwaveReady == false):
					microwave_timer.start()
					microwaveStarted = true
					print("Microwave Started")
				if (microwaveReady == true):
					get_tree().call_group("Employees", "_on_task_goal_complete", objectTaskID)
					microwaveReady = false
					
			_: # Error Catching
				print("Invalid Task Object: ", objectTaskID)
	
# Reset Plant Water Timer / Progress Bar
func _on_plant_area_exited(area):
	print("area exited")
	if plant_timer.time_left != 0:
		plant_timer.stop()
		plant_control.hide()
		print("Plant Watering Stopped")

# Water plant task finish Function
func _on_plant_timer_timeout():
	get_tree().call_group("Employees", "_on_task_remote_complete", objectTaskID)
	plant_control.hide()
	print("Plant Watered")

# Microwave Finished Heating Timer
func _on_microwave_timer_timeout():
	microwaveStarted = false
	microwaveReady = true
	print("Microwave Finished")
