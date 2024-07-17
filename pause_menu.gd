extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_volume_value_changed(value):
	pass # Replace with function body.


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 
		linear_to_db(value))


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 
		linear_to_db(value))


func _on_resolution_pressed():
	pass # Replace with function body.


func _on_resume_button_pressed():
	hide()


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_display_pressed():
	pass # Replace with function body.
