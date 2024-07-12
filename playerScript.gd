extends CharacterBody2D

var speed = 600.0
var accel = 5
var rng = RandomNumberGenerator.new()
var tasks: Array = []
var taskCount = 0

var input: Vector2

func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input.normalized()
	
func _process(delta):
	var playerInput = get_input()
	
	velocity = lerp(velocity, playerInput * speed, delta * accel)
	
	move_and_slide()

