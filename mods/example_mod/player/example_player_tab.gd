extends Control

@onready var break_button: Button = %BreakButton
@onready var counter: Label = %Counter

const BREAK_DURATION = 5 * 60

var break_controller: Tween

func _ready():
    break_button.pressed.connect(_break)

func _break():
    if break_controller:
        break_controller.kill()
    break_controller = create_tween()
    break_controller.tween_callback(_start_break)
    break_controller.tween_method(_update_counter, BREAK_DURATION, 0, BREAK_DURATION)
    break_controller.tween_callback(_stop_break)

func _start_break():
    get_tree().paused = true
    counter.show()

func _stop_break():
    get_tree().paused = false
    counter.hide()

func _update_counter(value: int):
    var mins = value / 60
    var secs = value % 60
    counter.text = str(mins).pad_zeros(2) + ":" + str(secs).pad_zeros(2)
