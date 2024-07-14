extends MarginContainer

# When a task is instanced, the bar starts decreasing until either the task is finished or it goes to zero.
# The task sends out a signal when the task is complete or when the task fails.

signal on_task_complete
signal on_task_fail

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
