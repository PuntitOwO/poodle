class_name LineWidget
extends Widget

@export var entity: LineEntity
@onready var line: Line2D = $Line
var tween: Tween

func _ready():
	init()

func init() -> void:
	line.hide()

func play(duration: float) -> void:
	line.show()
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_method(_add_points, 0, len(entity.points) - 1, duration)

func unplay():
	if tween:
		tween.kill()
	line.hide()

func _add_points(i: int) -> void:
	line.add_point(entity.points[i])