extends Control

@onready var break_button: Button = %BreakButton
@onready var pause_overlay: CanvasLayer = %PauseOverlay
@onready var resume_button: Button = %ResumeButton
@onready var progress_clock: TextureProgressBar = %ProgressClock
@onready var counter: Label = %Counter

const BREAK_DURATION = 5 * 60

var break_controller: Tween

func _ready():
    break_button.pressed.connect(_break)
    resume_button.pressed.connect(_stop_break)
    progress_clock.max_value = BREAK_DURATION

func _break():
    if break_controller:
        break_controller.kill()
    break_controller = create_tween()
    break_controller.tween_callback(_start_break)
    break_controller.tween_method(_update_counter, BREAK_DURATION, 0, BREAK_DURATION)
    break_controller.tween_callback(_stop_break)

func _start_break():
    get_tree().paused = true
    pause_overlay.visible = true

func _stop_break():
    get_tree().paused = false
    pause_overlay.visible = false
    if break_controller:
        break_controller.kill()

func _update_counter(value: int):
    progress_clock.value = value
    var mins = value / 60
    var secs = value % 60
    counter.text = str(mins).pad_zeros(2) + ":" + str(secs).pad_zeros(2)
