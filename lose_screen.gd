extends Control

@onready var score = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Score
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")

func update_score(value):
	score.text = str(value)
