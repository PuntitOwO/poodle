extends Node2D

@export var resource: LineEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	_play()

func _play():
	var line = Line2D.new()
	add_child(line)
	line.points = resource.points