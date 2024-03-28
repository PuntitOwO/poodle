class_name CodeTextWidget
extends Widget

@export var entity: CodeTextEntity
@onready var text_edit: TextEdit = $TextEdit

func _ready():
	init()

func init() -> void:
	text_edit.text = entity.content

func play(_duration: float) -> void:
	text_edit.show()	

func reset():
	text_edit.hide()