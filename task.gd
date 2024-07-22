extends MarginContainer

var id: int
var timer_on = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if timer_on:
		$IndivTaskContainer/TaskTimerBar.value = snapped($Timer.time_left, 0.01)

func init_task(new_name, new_time, new_id):
	$IndivTaskContainer/TaskLabel.text = new_name
	$Timer.wait_time = new_time
	id = new_id
	$IndivTaskContainer/TaskTimerBar.max_value = new_time
	$IndivTaskContainer/TaskTimerBar.value = new_time
	timer_on = true

func get_id() -> int:
	return id

func get_task_name() -> String:
	return $IndivTaskContainer/TaskLabel.text

func _on_timer_timeout():
	timer_on = false

func update_name(new_name):
	$IndivTaskContainer/TaskLabel.text = new_name
