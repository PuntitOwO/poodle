class_name Background
extends Node2D

const SCREEN_SIZE = Vector2i(1080, 720)
const MULTIPLIER = 5

@export var grid_size: int = 10:
	set(value):
		grid_size = value
		queue_redraw()
@export var show_grid: bool = true:
	set(value):
		if value == show_grid:
			return
		show_grid = value
		print("Show grid: ", show_grid)
		queue_redraw()

func _ready():
	get_parent().motion_mirroring = SCREEN_SIZE * MULTIPLIER
	$ColorRect.size = SCREEN_SIZE * MULTIPLIER
	$ColorRect.show()
	set_background_color(Color(0.1, 0.1, 0.1))
	set_background_variant_color(Color(0.5, 0.5, 0.5))

func _draw():
	if show_grid:
		draw_multiline(_generate_lines(), Color.WHITE)
	for x in MULTIPLIER:
		for y in MULTIPLIER:
			draw_rect(Rect2(SCREEN_SIZE * Vector2i(x, y), SCREEN_SIZE), Color.WHITE, false, 2 if show_grid else 4)

func _generate_lines() -> PackedVector2Array:
	var points: PackedVector2Array = PackedVector2Array()
	var window_size: Vector2 = SCREEN_SIZE * MULTIPLIER
	for x in window_size.x / grid_size:
		points.append(Vector2(x * grid_size, 0))
		points.append(Vector2(x * grid_size, window_size.y))
	for y in window_size.y / grid_size:
		points.append(Vector2(0, y * grid_size))
		points.append(Vector2(window_size.x, y * grid_size))
	return points

## Set the background color of the scene.
func set_background_color(color: Color) -> void:
	$ColorRect.modulate = color

## Set the background variants color of the scene.
func set_background_variant_color(color: Color) -> void:
	self_modulate = color
