extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$Settings/PanelContainer/MarginContainer/VBoxContainer/Volume.value = 0.75
	$Settings/PanelContainer/MarginContainer/VBoxContainer/SFX.value = 0.5
	$Settings/PanelContainer/MarginContainer/VBoxContainer/Music.value = 0.35
	$Music.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_button_pressed():
	$ClickSFX.play()
	get_tree().quit()


func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 
		linear_to_db(value))


func _on_resolution_item_selected(index):
	match index:
		0:
			$ClickSFX.play()
			DisplayServer.window_set_size(Vector2i(2560, 1440))
		1:
			$ClickSFX.play()
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		2:
			$ClickSFX.play()
			DisplayServer.window_set_size(Vector2i(1366, 768))
		3:
			$ClickSFX.play()
			DisplayServer.window_set_size(Vector2i(1280, 720))


func _on_option_button_item_selected(index):
	match index:
		0:
			$ClickSFX.play()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			$ClickSFX.play()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(DisplayServer.window_get_size())
		2:
			$ClickSFX.play()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _on_settings_button_pressed():
	$ClickSFX.play()
	$Settings.show()


func _on_settings_back_button_pressed():
	$ClickSFX.play()
	$Settings.hide()


func _on_start_button_pressed():
	$ClickSFX.play()
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://game.tscn")


func _on_credits_button_pressed():
	$ClickSFX.play()


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 
		linear_to_db(value))


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 
		linear_to_db(value))
