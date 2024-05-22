class_name ClassCamera
extends Camera2D

## Emitted when the user starts or stops controlling the camera.
signal user_controlled_changed(value: bool)

const KEY_MOVEMENT_SPEED = 20
const GRID_ZOOM_THRESHOLD = 0.6
var velocity := Vector2.ZERO
var tween: Tween
var user_controlled: bool = false:
    set(value):
        user_controlled = value
        if not value:
            _recenter()
        elif is_instance_valid(tween):
            tween.kill()
        user_controlled_changed.emit(value)
@export var background: Background

func _enter_tree():
    if is_instance_valid(ClassUI.context):
        ClassUI.context.camera = self

func _process(_delta):
    if Input.is_action_just_pressed("camera_recenter") and user_controlled:
        user_controlled = false
        return
    var input := Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")
    if input.is_zero_approx():
        velocity = velocity.move_toward(Vector2.ZERO, 1.0)
    else:
        user_controlled = true
        velocity = velocity.move_toward(input * KEY_MOVEMENT_SPEED, 0.6)
    position += velocity * zoom
    var zoom_input := Input.get_axis("camera_zoom_out", "camera_zoom_in")
    if is_zero_approx(zoom_input):
        return
    zoom_input = zoom_input * 0.005 + 1.0
    zoom *= zoom_input
    background.show_grid = zoom.x > GRID_ZOOM_THRESHOLD

## Move the camera to the target position in global coordinates
func move_to(target: Vector2) -> void:
    if user_controlled:
        return
    if is_instance_valid(tween):
        tween.kill()
    tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(self, ^"global_position", target, 1.0)

func _recenter():
    var target_node := get_tree().get_first_node_in_group(&"current_slide") as SlideNode
    if not is_instance_valid(target_node):
        return
    move_to(target_node.get_camera_target_position())