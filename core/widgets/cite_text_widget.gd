class_name CiteTextWidget
extends Widget

const scene = preload("res://core/widgets/cite_text_widget.tscn")

@export var entity: CiteTextEntity
var label: Label
var tween: Tween

func init(properties: Dictionary) -> void:
	label = scene.instantiate()
	add_child(label)
	if properties.has("position"):
		position = properties["position"]
	if properties.has("size"):
		label.size = properties["size"]
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