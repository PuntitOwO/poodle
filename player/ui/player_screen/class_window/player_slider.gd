class_name PlayerSlider
extends HSlider

## A custom slider that is used to control the playback of a class.
##
## It is a horizontal slider that has a thumb that can be dragged to change the position of the class.
## It has a debouncer to prevent the signal from being emitted too many times.

## Emitted when the value of the slider is changed.
signal value_selected(value: float)

@export var debouncer_time = 0.2
@onready var pressed: bool = false
@onready var debouncer: Timer = Timer.new()

## Change the value of the slider, with or without emitting the signal.
func change_value(new_value: float, _emit_signal: bool = false) -> void:
    if pressed:
        return
    if _emit_signal:
        value = new_value
    else:
        set_value_no_signal(new_value)

func _ready() -> void:
    debouncer.wait_time = debouncer_time
    debouncer.one_shot = true
    add_child(debouncer)
    debouncer.timeout.connect(_emit_change_value)
    value_changed.connect(_on_value_changed)


func _emit_change_value() -> void:
    emit_signal("value_selected", value)
    pressed = false

func _on_value_changed(_value: float) -> void:
    pressed = true
    debouncer.start()
    change_value(_value, false)