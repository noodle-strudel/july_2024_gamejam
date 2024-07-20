extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	var pitch_shift = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"), 0)
	pitch_shift.pitch_scale = 1
	$Music.play()
	$Environment.play()
	$CanvasLayer.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _unhandled_input(event):
	if event.is_action_pressed("pause") && get_tree().paused == false:
		$CanvasLayer/GameUI/PauseMenu.show()
		get_tree().paused = true

func _on_music_finished():
	$MusicRepeat.play()


func _on_player_lose_game(value):
	get_tree().paused = true
	$CanvasLayer/GameUI/LoseScreen.update_score(value)
	$CanvasLayer/GameUI/LoseScreen.show()
