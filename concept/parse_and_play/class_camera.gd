class_name ClassCamera
extends Camera2D

## Emitted when the user starts or stops controlling the camera.
signal user_controlled_changed(value: bool)

const KEY_MOVEMENT_SPEED = 20
const ZOOM_CHANGE_SPEED = 0.005
const GRID_ZOOM_THRESHOLD = 0.85
const MIN_ZOOM = 0.5
const MAX_ZOOM = 3.0

var velocity := Vector2.ZERO
var tween: Tween
var time_scale: float = 1.0
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
    add_to_group(&"speed_scale_handler")
    if is_instance_valid(ClassUI.context):
        ClassUI.context.camera = self

func set_speed_scale(_speed: float) -> void:
    time_scale = 1.0 / _speed
    if is_instance_valid(tween) and tween.is_valid():
        tween.set_speed_scale(time_scale)

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
    zoom_input = zoom_input * ZOOM_CHANGE_SPEED * time_scale + 1.0
    zoom *= zoom_input
    zoom = zoom.clamp(Vector2.ONE * MIN_ZOOM, Vector2.ONE * MAX_ZOOM)
    update_grid_visibility()

func update_grid_visibility():
    background.show_grid = zoom.x > GRID_ZOOM_THRESHOLD

## Move the camera to the target position in global coordinates
func move_to(target_position: Vector2, target_zoom: float = -1.0) -> void:
    if user_controlled:
        return
    if is_instance_valid(tween):
        tween.kill()
    tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT).set_parallel().set_speed_scale(time_scale)
    tween.tween_property(self, ^"global_position", target_position, 1.0)
    if target_zoom > 0.0:
        tween.tween_property(self, ^"zoom", Vector2.ONE * target_zoom, 1.0)
        tween.chain().tween_callback(update_grid_visibility)

func _recenter():
    var target_node := get_tree().get_first_node_in_group(&"current_slide") as SlideNode
    if not is_instance_valid(target_node):
        return
    move_to(target_node.get_camera_target_position())

func interpolate_zoom(target_zoom: float):
    if is_instance_valid(tween):
        tween.kill()
    tween = create_tween().set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_IN_OUT).set_speed_scale(time_scale)
    tween.tween_property(self, ^"zoom", Vector2.ONE * target_zoom, 1.0)
    tween.tween_callback(update_grid_visibility)

func reset_zoom():
    interpolate_zoom(1.0)