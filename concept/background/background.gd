@tool
extends Node2D

@export var grid_size: int = 10:
	set(value):
		grid_size = value
		queue_redraw()

func _ready():
	if Engine.is_editor_hint():
		$ColorRect.hide()
		return
	$ColorRect.show()
	set_background_color(Color(0.1, 0.1, 0.1))
	set_background_variant_color(Color(0.5, 0.5, 0.5))

func _draw():
	draw_multiline(_generate_lines(), Color.WHITE)

func _generate_lines() -> PackedVector2Array:
	var points: PackedVector2Array = PackedVector2Array()
	var window_size: Vector2 = _normalize_viewport_size()
	for x in window_size.x / grid_size:
		points.append(Vector2(x * grid_size, 0))
		points.append(Vector2(x * grid_size, window_size.y))
	for y in window_size.y / grid_size:
		points.append(Vector2(0, y * grid_size))
		points.append(Vector2(window_size.x, y * grid_size))
	return points

func _normalize_viewport_size() -> Vector2:
	var window_size: Vector2 = get_viewport_rect().size
	var new_size: Vector2 = window_size / grid_size
	new_size.x = ceil(new_size.x)
	new_size.y = ceil(new_size.y)
	new_size *= grid_size
	if !Engine.is_editor_hint():
		get_parent().motion_mirroring = new_size
	$ColorRect.size = new_size
	return new_size

## Set the background color of the scene.
func set_background_color(color: Color) -> void:
	$ColorRect.modulate = color

## Set the background variants color of the scene.
func set_background_variant_color(color: Color) -> void:
	self_modulate = color
