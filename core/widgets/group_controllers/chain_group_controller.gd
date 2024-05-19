class_name ChainGroupController
extends GroupController

## A [GroupController] that runs its children in sequence.

var _durations: Array[float] = []
var _cancelled: bool = false

## Computes the duration of this group.
## It is the sum of the duration of all the children.
func _compute_duration() -> float:
    var duration: float = 0.0
    for child in get_children():
        var child_duration: float = child.compute_duration()
        duration += child_duration
        _durations.append(child_duration)
    return duration

## Runs the children in sequence.
## It waits for each children to finish before starting the next.
func play(__duration: float = _duration) -> void:
    _cancelled = false
    for child_idx in get_child_count():
        var child = get_child(child_idx)
        child.play(_durations[child_idx])
        await child.animation_finished
        if _cancelled:
            return
    animation_finished.emit()

## Cancels the group running and calls [method GroupController.reset].
func reset() -> void:
    _cancelled = true
    super.reset()

func skip_to_end() -> void:
    _cancelled = true
    super.skip_to_end()