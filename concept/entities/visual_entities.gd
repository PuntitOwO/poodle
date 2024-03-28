extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().create_timer(3.0).timeout.connect(_on_timeout)

func _on_timeout():
	propagate_call("play")

func _unhandled_key_input(event):
	if event.keycode == KEY_SPACE:
		get_tree().reload_current_scene()
