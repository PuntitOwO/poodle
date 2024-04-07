class_name ParallelGroupController
extends GroupController

## A [GroupController] that runs its children in parallel.

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
    get_tree().create_timer(duration, false).timeout.connect(emit_signal.bind("animation_finished"))
