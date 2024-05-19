class_name ChainGroupController
extends GroupController

## A [GroupController] that runs its children in sequence.

var _durations: Array[float] = []

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
    _connect_signals()
    get_child(0).play(_durations[0])

## Cancels the group running and calls [method GroupController.reset].
func reset() -> void:
    _disconnect_signals()
    super.reset()

func skip_to_end() -> void:
    _disconnect_signals()
    super.skip_to_end()

func _connect_signals() -> void:
    var last_child = get_child(get_child_count() - 1)
    last_child.connect(&"animation_finished", _emit_animation_finished, CONNECT_ONE_SHOT)
    if get_child_count() == 1:
        return
    for child_idx in get_child_count() - 1:
        var child = get_child(child_idx)
        var next_child = get_child(child_idx + 1)
        child.connect(&"animation_finished", next_child.play.bind(_durations[child_idx + 1]), CONNECT_ONE_SHOT)

func _disconnect_signals() -> void:
    var last_child = get_child(get_child_count() - 1)
    if last_child.is_connected(&"animation_finished", _emit_animation_finished):
        last_child.disconnect(&"animation_finished", _emit_animation_finished)
    if get_child_count() == 1:
        return
    for child_idx in get_child_count() - 1:
        var child = get_child(child_idx)
        var next_child = get_child(child_idx + 1)
        if child.is_connected(&"animation_finished", next_child.play.bind(_durations[child_idx + 1])):
            child.disconnect(&"animation_finished", next_child.play.bind(_durations[child_idx + 1]))
