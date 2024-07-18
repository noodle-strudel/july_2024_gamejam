extends Control

@onready var task_scene = preload("res://task.tscn")
@onready var task_container = $TaskPanelContainer/VBoxContainer/TaskContainer
@onready var score = $ScorePanelContainer/MarginContainer/HSplitContainer/Score
@onready var warning_container = $WarningPanelContainer/MarginContainer/WarningsContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Creates a task given the name of the task and how long it takes before it disappears
func create_task(task_name, task_time, task_id):
	var new_task = task_scene.instantiate()
	new_task.init_task(task_name, task_time, task_id)
	task_container.add_child(new_task)
	print("New task has id", task_id)

# Remove the task by id
func remove_task(task_id):
	for task in task_container.get_children():
		print(task)
		if task.get_id() == task_id:
			task.queue_free()
			print("task with id", task_id, "removed")

# Update the score shown in the UI
func update_score(value : String):
	score.text = value

# Update the warnings shown in the UI
func add_warning(num):
	# unhides the corresponding warning, given a number between 0-2 (3 unique warnings in total)
	warning_container.get_child(num).show()
