class_name CodeTextWidget
extends Widget

@export var entity: CodeTextEntity
@onready var text_edit: TextEdit = $TextEdit

func init(properties: Dictionary) -> void:
	if properties.has("position"):
		position = properties["position"]
	if properties.has("size"):
		text_edit.size = properties["size"]
	text_edit.text = entity.content

func play(_duration: float) -> void:
	text_edit.show()	

func reset():
	text_edit.hide()