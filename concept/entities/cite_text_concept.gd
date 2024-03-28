extends Node2D

@export var resource: CiteTextEntity

var widget: Label
# Called when the node enters the scene tree for the first time.
func _ready():
	init()

func init():
	widget = Label.new()
	widget.hide()
	widget.text = resource.content
	add_child(widget)

func play():
	widget.show()

func unplay():
	widget.hide()