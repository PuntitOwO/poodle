class_name CodeTextWidget
extends Widget

const scene = preload("res://core/widgets/code_text_widget.tscn")

@export var entity: CodeTextEntity
var text_edit: TextEdit

func init(properties: Dictionary) -> void:
	text_edit = scene.instantiate()
	add_child(text_edit)
	if properties.has("position"):
		position = properties["position"]
	if properties.has("size"):
		text_edit.size = properties["size"]
	text_edit.text = entity.content

func play(_duration: float) -> void:
	text_edit.show()
	_emit_animation_finished()

func reset():
	text_edit.hide()

func skip_to_end():
	text_edit.show()
