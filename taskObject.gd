extends Area2D
signal taskGoalComplete(value)
signal taskRemoteComplete(value)
signal deliveryUpdated(value)

@onready var plant_timer = $"../Plant/PlantTimer"
@onready var plant_control = $"../Plant/PlantControl"
@onready var plant_progress = $"../Plant/PlantControl/ProgressBar"
@onready var microwave_timer = $"../Microwave/MicrowaveTimer"
@export var objectTaskID = 0
@onready var animations = $AnimationPlayer

var collidedBody
var microwaveStarted = false
var microwaveReady = false
var deliveryTaskStep = 0

# Connect Signals
func _ready():
	%Player.taskInList.connect(_on_task_in_list)

func _physics_process(delta):
	plant_progress.value = -plant_timer.time_left

# Tell Player to check if task is in list
func _on_body_entered(body):
	collidedBody = body.name
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
				$"../Cooler/CoolerFX".play()
				$"../Cooler/AnimationPlayer".play("idle")
			2: # Printer Task
				get_tree().call_group("Employees", "_on_task_remote_complete", objectTaskID)
				print("Printer Fixed")
				$PrinterFX.play()
				$AnimationPlayer.play("default")
			3: # Whiteboard Task
				get_tree().call_group("Employees", "_on_task_remote_complete", objectTaskID)
				print("Erased Whiteboard")
				$"../WhiteBoard/WhiteBoardFX".play()
				$"../WhiteBoard/AnimationPlayer".play("idle")
			4: # Water Plant
				plant_timer.start()
				plant_control.show()
				print("Watering Plant...")
				$"../Plant/PlantFX".play()
			5: # Microwave
				if (microwaveStarted == false && microwaveReady == false):
					microwave_timer.start()
					microwaveStarted = true
					print("Microwave Started")
					$"../Microwave/MicrowaveFX".play()
				if (microwaveReady == true):
					get_tree().call_group("Employees", "_on_task_goal_complete", objectTaskID)
					microwaveReady = false
					
			6: # Delivery
				if (deliveryTaskStep == 0 && self.name == "Files" && collidedBody == "Player"):
					print("Files Grabbed")
					deliveryTaskStep = 1
					collidedBody = "null"
					%Storage.deliveryTaskStep = 1
					return
				if (deliveryTaskStep == 1 && self.name == "Storage" && collidedBody == "Player"):
					print("Delivered")
					deliveryTaskStep = 0
					collidedBody = "null"
					%Files.deliveryTaskStep = 0
					get_tree().call_group("Employees", "_on_task_remote_complete", objectTaskID)
					return
					
				collidedBody = "null"
			_: # Error Catching
				print("Invalid Task Object: ", objectTaskID)
	
# Reset Plant Water Timer / Progress Bar
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

# Microwave Finished Heating Timer
func _on_microwave_timer_timeout():
	$"../Microwave/MicrowaveFX".stop()
	$"../Microwave/MicrowaveFXend".play()
	microwaveStarted = false
	microwaveReady = true
	print("Microwave Finished")

