extends Node2D

@export var resource: CodeTextEntity

var widget: TextEdit
# Called when the node enters the scene tree for the first time.
func _ready():
	init()

func init():
	widget = TextEdit.new()
	var highlighter: CodeHighlighter = preload("res://concept/code_highlighter/godot_editor_gdscript.tres")
	widget.text = resource.content
	widget.editable = false
	widget.hide()
	widget.syntax_highlighter = highlighter
	widget.custom_minimum_size = Vector2(300, 300)
	add_child(widget)

func play():
	widget.show()

func unplay():
	widget.hide()