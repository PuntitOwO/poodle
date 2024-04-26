@icon("res://utils/stopwatch_icon.svg")
class_name Stopwatch
extends Node

## A stopwatch node that can be used to measure time in the game.
##
## The stopwatch can be used to measure time in the game. It can be started, stopped, and paused.
## The stopwatch can also be set to autostart, which will start the stopwatch when the scene is loaded.
## It is based on a [Timer] node, so it has the same issues as the Timer node.


## The process callback for the stopwatch.
enum StopwatchProcessCallback {
    STOPWATCH_PROCESS_PHYSICS = 0, ## Update the stopwatch during physics frames (see [enum Timer.TimerProcessCallback]).
    STOPWATCH_PROCESS_IDLE = 1, ## Update the stopwatch during idle frames (see [enum Timer.TimerProcessCallback]).
}

const MAX_TIME = 1000000000

## If `true`, the stopwatch will automatically start when entering the scene tree. See [member Timer.autostart].
@export var autostart: bool = false
## If `true`, the stopwatch is paused and will not process until it is unpaused again, even if [method start] is called. See [member Timer.paused].
@export var paused: bool = false
@export var process_callback: StopwatchProcessCallback = StopwatchProcessCallback.STOPWATCH_PROCESS_IDLE
## The stopwatch's current time in seconds. [br]
## [b] Note [/b]: This property is read-only.
@export var running_time: float:
    get:
        return _time + (MAX_TIME - timer.time_left)
    set(_value):
        printerr("Stopwatch.running_time is read-only.")
@onready var timer: Timer = Timer.new()

var _time: float = 0
var _stopped_time: float = 0

func _ready():
    timer.autostart = autostart
    timer.paused = paused
    timer.wait_time = MAX_TIME
    timer.one_shot = false
    timer.process_callback = Timer.TIMER_PROCESS_IDLE if process_callback == StopwatchProcessCallback.STOPWATCH_PROCESS_IDLE else Timer.TIMER_PROCESS_PHYSICS
    add_child(timer, false, INTERNAL_MODE_FRONT)

## Returns `true` if the stopwatch is stopped.
func is_stopped() -> bool:
    return timer.is_stopped()

## Starts the stopwatch. Sets the stopwatch's time to `initial_time`.
func start(initial_time: float = 0.0) -> void:
    _time = initial_time
    timer.start()

## Stops the stopwatch.
func stop() -> void:
    _stopped_time = running_time
    timer.stop()

## Starts the stopwatch with the time it was stopped at.
func resume() -> void:
    start(_stopped_time)