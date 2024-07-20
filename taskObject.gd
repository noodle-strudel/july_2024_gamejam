extends Area2D
signal taskGoalComplete(value)
signal taskRemoteComplete(value)

@onready var plant_timer = $"../Plant/PlantTimer"
@onready var plant_control = $"../Plant/PlantControl"
@onready var plant_progress = $"../Plant/PlantControl/ProgressBar"
@export var objectTaskID = 0

var player : Node

func _ready():
	%Player.taskInList.connect(_on_task_in_list)
	
func _physics_process(delta):
	plant_progress.value = -plant_timer.time_left

func _on_body_entered(body):
	%Player._on_checkTaskInList(objectTaskID)

func _on_task_in_list(value):
	if (objectTaskID == value):
		match objectTaskID:
			1: 
				get_tree().call_group("Employees", "_on_task_goal_complete", objectTaskID)
				print("Bring back water")
			2:
				get_tree().call_group("Employees", "_on_task_remote_complete", objectTaskID)
				print("Printer Fixed")
			3:
				get_tree().call_group("Employees", "_on_task_remote_complete", objectTaskID)
				print("Erased Whiteboard")
			4:
				plant_timer.start()
				plant_control.show()
				print("Watering Plant...")
			_:	 	
				print("Invalid Task Object: ", objectTaskID)
				
func _on_plant_area_exited(area):
	print("area exited")
	if plant_timer.time_left != 0:
		plant_timer.stop()
		plant_control.hide()
		print("Plant Watering Stopped")

func _on_plant_timer_timeout():
	get_tree().call_group("Employees", "_on_task_remote_complete", objectTaskID)
	plant_control.hide()
	print("Plant Watered")
