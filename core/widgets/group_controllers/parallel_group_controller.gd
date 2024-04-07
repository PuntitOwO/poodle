class_name ParallelGroupController
extends GroupController

## A [GroupController] that runs its children in parallel.

var _timer: SceneTreeTimer

## Computes the duration of this group.
## The duration of a parallel group is the maximum duration of all its children.
func _compute_duration() -> float:
    var duration: float = 0.0
    for child in get_children():
        if child.has_method("compute_duration"):
            duration = max(duration, child.compute_duration())
    return duration

## Runs all children in parallel.
## This means that all children will be played at the same time.
func play(duration: float = _duration) -> void:
    for child in get_children():
        if child.has_method("play"):
            child.play(duration)
    _timer = get_tree().create_timer(duration, false)
    _timer.timeout.connect(_emit_animation_finished, CONNECT_ONE_SHOT)

## Disconnects the animation finished method and calls [method GroupController.reset].
func reset() -> void:
    if _timer.timeout.is_connected(_emit_animation_finished):
        _timer.timeout.disconnect(_emit_animation_finished)
    super.reset()

func _emit_animation_finished() -> void:
    animation_finished.emit()