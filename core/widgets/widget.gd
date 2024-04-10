class_name Widget
extends Node2D

## A widget is a visual element that can be played and reset.
## This class defines the main API for a widget.

signal animation_finished

## The ZIP file containing the widget assets.
## Use [method ZIPReader.file_exists] to check if a file exists in the ZIP file.
## Use [method ZIPReader.read_file] to get a file from the ZIP file.
static var zip_file: ZIPReader

## Compute the duration of the widget animation.
func compute_duration() -> float:
	return 0.0

## Called when the node enters the scene tree for the first time.
## It is a good place to initialize the node with the entity's properties
## and instantiate any children.
## 
## Custom [param properties] are passed as a dictionary.
func init(_properties: Dictionary) -> void:
	pass

## Called when it's time to play the widget.
## The animation should be played for the given [param duration].
func play(_duration: float) -> void:
	pass

## Called when the player seeked to a point before the widget was played.
## The widget should be reset to its initial state.
func reset() -> void:
	pass

## Called when the player seeked to a point after the widget was played.
## The widget should be set to its final state.
func skip_to_end() -> void:
	pass

## Set the speed scale of the widget.
## The [param speed] scale is a multiplier that affects the speed of the widget.
## A speed scale of 1.0 means the widget will play at its normal speed.
func set_speed_scale(_speed: float) -> void:
	pass

## Reset the speed scale of the widget to 1.0.
func reset_speed_scale() -> void:
	set_speed_scale(1.0)

func _emit_animation_finished() -> void:
	animation_finished.emit()