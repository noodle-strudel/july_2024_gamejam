extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Settings/PanelContainer/MarginContainer/VBoxContainer/Volume.value = GameSettings.master_vol
	$Settings/PanelContainer/MarginContainer/VBoxContainer/SFX.value = GameSettings.sfx_vol
	$Settings/PanelContainer/MarginContainer/VBoxContainer/Music.value = GameSettings.music_vol
	$Settings/PanelContainer/MarginContainer/VBoxContainer/Resolution.selected = GameSettings.resolution_id
	$Settings/PanelContainer/MarginContainer/VBoxContainer/Display.selected = GameSettings.display_id


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_volume_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 
		linear_to_db(value))
	GameSettings.master_vol = value


func _on_sfx_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), 
		linear_to_db(value))
	GameSettings.sfx_vol = value


func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), 
		linear_to_db(value))
	GameSettings.music_vol = value


func _on_resume_button_pressed():
	get_tree().paused = false
	hide()


func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://main.tscn")


func _on_display_item_selected(index):
	$ClickSFX.play()
	match index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_size(DisplayServer.window_get_size())
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	GameSettings.display_id = index


func _on_resolution_item_selected(index):
	$ClickSFX.play()
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(2560, 1440))
		1:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		2:
			DisplayServer.window_set_size(Vector2i(1366, 768))
		3:
			DisplayServer.window_set_size(Vector2i(1280, 720))
	GameSettings.resolution_id = index
