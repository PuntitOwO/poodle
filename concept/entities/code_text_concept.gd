extends Node2D

@export var resource: CodeTextEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	_play()

func _play():
	var code_block: TextEdit = TextEdit.new()
	var highlighter: CodeHighlighter = preload("res://concept/code_highlighter/godot_editor_gdscript.tres")
	code_block.text = resource.content
	code_block.editable = false
	code_block.syntax_highlighter = highlighter
	code_block.custom_minimum_size = Vector2(300, 300)
	add_child(code_block)
