extends Area2D
signal taskGoalComplete(value)
signal taskRemoteComplete(value)

@export var objectTaskID = 0

func _on_body_entered(body):	
	print("\nCollided\n")
	match objectTaskID:
		1: 
			get_tree().call_group("Employees", "_on_task_goal_complete", objectTaskID)
			print("Bring back water")
			return
		2:
			get_tree().call_group("Employees", "_on_task_remote_complete", objectTaskID)
			print("Printer Fixed")
			return
		_:
			print("Invalid Task Object: ", objectTaskID)
