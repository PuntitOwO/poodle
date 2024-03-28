class_name ChainGroupController
extends GroupController

## A [GroupController] that runs its children in sequence.

## Computes the duration of this group.
## It is the sum of the duration of all the children.
func compute_duration() -> float:
    var duration = 0.0
    for child in get_children():
        duration += child.compute_duration()
    return duration

## Runs the children in sequence.
## It waits for each children to finish before starting the next.
func play(duration: float) -> void:
    for child in get_children():
        child.play(duration)
        await child.animation_finished