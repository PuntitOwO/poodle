extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().create_timer(3.0).timeout.connect(_on_timeout)

func _on_timeout():
	propagate_call("play")
