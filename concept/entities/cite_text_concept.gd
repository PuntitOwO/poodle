extends Node2D

@export var resource: CiteTextEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	_play()

func _play():
	var cite_block: Label = Label.new()
	cite_block.text = resource.content
	add_child(cite_block)
