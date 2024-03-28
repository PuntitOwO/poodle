extends Node2D

@export var resource: LineEntity

var widget: Line2D
# Called when the node enters the scene tree for the first time.
func _ready():
	init()

func init():
	widget = Line2D.new()
	widget.points = resource.points
	widget.hide()
	add_child(widget)

func play():
	widget.show()

func reset():
	widget.hide()