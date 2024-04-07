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
	label.text = entity.content

func play(duration: float) -> void:
	label.show()
	if tween:
		tween.kill()
	if !is_zero_approx(duration):
		tween = create_tween()
		tween.tween_property(label, "visible_ratio", 1, duration).from(0)
		tween.tween_callback(_emit_animation_finished)
	else:
		label.visible_ratio = 1
		_emit_animation_finished()

func reset():
	if tween:
		tween.kill()
	label.hide()