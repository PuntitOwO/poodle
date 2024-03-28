class_name ChainGroupController
extends GroupController

## A [GroupController] that runs its children in sequence.

var _duration: float = 0.0
var _durations: Array[float] = []

## Computes the duration of this group.
## It is the sum of the duration of all the children.
func compute_duration() -> float:
    if is_zero_approx(_duration):
        for child in get_children():
            var duration = child.compute_duration()
            _duration += duration
            _durations.append(duration)
    return _duration

## Runs the children in sequence.
## It waits for each children to finish before starting the next.
func play(__duration: float) -> void:
    for child_idx in get_child_count():
        var child = get_child(child_idx)
        child.play(_durations[child_idx])
        await child.animation_finished
    animation_finished.emit()