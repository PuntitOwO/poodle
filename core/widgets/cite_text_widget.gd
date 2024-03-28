class_name CiteTextWidget
extends Widget

@export var entity: CiteTextEntity
@onready var label: Label = $Label
var tween: Tween

func _ready():
	init()	

func init() -> void:
	label.text = entity.text

func play(duration: float) -> void:
	label.show()
	if tween:
		tween.kill()
	label.visible_ratio = 0
	tween = create_tween()
	tween.tween_property(label, "visible_ratio", 1, duration)

func reset():
	if tween:
		tween.kill()
	label.hide()