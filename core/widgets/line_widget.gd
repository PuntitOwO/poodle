class_name LineWidget
extends Widget

const scene = preload("res://core/widgets/line_widget.tscn")

@export var entity: LineEntity
var line: Line2D
var tween: Tween

func init(properties: Dictionary) -> void:
	line = scene.instantiate()
	add_child(line)
	if properties.has("position"):
		position = properties["position"]
	line.hide()

func play(duration: float) -> void:
	line.show()
	if tween:
		tween.kill()
	if !is_zero_approx(duration):
		tween = create_tween()
		tween.tween_method(_add_points, 0, len(entity.points) - 1, duration)

func reset():
	if tween:
		tween.kill()
	line.hide()
	line.clear_points()

func _add_points(i: int) -> void:
	line.add_point(entity.points[i])