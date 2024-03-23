extends Node2D

@export var resource: CodeTextEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	_play()

func _play():
	var code_block: CodeEdit = CodeEdit.new()
	code_block.text = resource.content
	add_child(code_block)
