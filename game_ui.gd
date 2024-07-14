extends Control

@onready var task_scene = preload("res://task.tscn")
@onready var task_container = $TaskPanelContainer/VBoxContainer/TaskContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Creates a task given the name of the task and how long it takes before it disappears
func create_task(task_name, task_time):
	var task = task_scene.instantiate()
	task.init_task(task_name, task_time)
