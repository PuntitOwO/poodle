class_name ParallelGroupController
extends GroupController

## A [GroupController] that runs its children in parallel.

## Computes the duration of this group.
## The duration of a parallel group is the maximum duration of all its children.
func compute_duration() -> float:
    var max_duration = 0.0
    for child in get_children():
        if child.has_method("compute_duration"):
            max_duration = max(max_duration, child.compute_duration())
    return max_duration

## Runs all children in parallel.
## This means that all children will be played at the same time.
func play(duration: float) -> void:
    for child in get_children():
        if child.has_method("play"):
            child.play(duration)