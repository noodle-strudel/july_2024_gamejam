extends Control

# creates a tween that interpolates properties of a node

@onready var signature := $PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Signature
@onready var signature_button := $PanelContainer/MarginContainer/PanelContainer/MarginContainer/VBoxContainer/SignatureButton
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_signature_button_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(signature, "visible_ratio", 1, 3)
	tween.finished.connect(_on_signature_complete)
	signature_button.queue_free()
	


func _on_signature_complete():
	await get_tree().create_timer(1).timeout
	get_tree().change_scene_to_file("res://game.tscn")
