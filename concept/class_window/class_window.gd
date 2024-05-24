class_name ConceptClassWindow
extends Control

var find_group_by_timestamp: Callable

#region Section Tree
@onready var section_tree_parent: Control = %LeftPanel

func set_section_tree(tree: Tree) -> void:
    section_tree_parent.add_child(tree)
    tree.item_activated.connect(_on_tree_section_clicked.bind(tree))

func _on_tree_section_clicked(tree: Tree) -> void:
    var selected: TreeItem = tree.get_selected()
    if !is_instance_valid(selected):
        return
    _play_section(selected)

func _play_section(selected: TreeItem) -> void:
    var slide: SlideNode = selected.get_metadata(0)
    if !is_instance_valid(slide):
        return
    var current_slide: SlideNode = (get_tree().get_first_node_in_group("current_slide") as SlideNode)
    var current_slide_index: int = 0
    if is_instance_valid(current_slide):
        # current_slide.stop()
        current_slide_index = current_slide.absolute_slide_id
    get_tree().call_group_flags(SceneTree.GROUP_CALL_DEFERRED, "slide_nodes", "on_seek", current_slide_index, slide.absolute_slide_id)
    slide.call_deferred(&"play")
#endregion

#region Whiteboard
func set_class_node(node: Node) -> void:
    node.reparent(%SubViewport)
#endregion

#region Playback
@onready var current_time_label: Label = %CurrentTimeLabel
@onready var time_slider: PlayerSlider = %TimeSlider
@onready var total_time_label: Label = %TotalTimeLabel
@onready var stopwatch: Stopwatch = %Stopwatch

func set_total_time(total_time: int) -> void:
    var total_time_string := _get_time_string(total_time)
    total_time_label.text = total_time_string
    time_slider.max_value = floorf(total_time)

func _get_time_string(time: int) -> String:
    var minutes := time / 60
    var seconds := time % 60
    return str(minutes).lpad(2, "0") + ":" + str(seconds).lpad(2, "0")
#endregion

#region Camera Zoom

@onready var zoom_slider: HSlider = %ZoomSlider
@onready var zoom_button: TextureButton = %ZoomButton

func _update_zoom_slider_value() -> void:
    if !is_instance_valid(ClassUI.context) or !is_instance_valid(ClassUI.context.camera):
        return
    var value: float = ClassUI.context.camera.zoom.x
    zoom_slider.set_value_no_signal(value)

func _zoom_slider_value_selected(value: float) -> void:
    if !is_instance_valid(ClassUI.context) or !is_instance_valid(ClassUI.context.camera):
        return
    ClassUI.context.camera.zoom = Vector2(value, value)
    ClassUI.context.camera.update_grid_visibility()

func _zoom_reset() -> void:
    if !is_instance_valid(ClassUI.context) or !is_instance_valid(ClassUI.context.camera):
        return
    ClassUI.context.camera.reset_zoom()

#endregion

#region Playback Controls

@onready var play_button: Button = %PlayPauseButton
@onready var prev_button: Button = %PreviousButton
@onready var next_button: Button = %NextButton
@onready var play_icon: Texture2D = get_theme_icon("play", play_button.theme_type_variation)
@onready var pause_icon: Texture2D = get_theme_icon("pause", play_button.theme_type_variation)
@onready var prev_icon: Texture2D = get_theme_icon("prev", prev_button.theme_type_variation)
@onready var next_icon: Texture2D = get_theme_icon("next", next_button.theme_type_variation)

func _toggle_playback() -> void:
    get_tree().paused = !get_tree().paused
    play_button.icon = play_icon if get_tree().paused else pause_icon

func _get_current_section() -> TreeItem:
    var current_slide: SlideNode = (get_tree().get_first_node_in_group("current_slide") as SlideNode)
    if !is_instance_valid(current_slide):
        return null
    return current_slide.tree_item

func _get_next_section() -> TreeItem:
    var current_item: TreeItem = _get_current_section()
    if !is_instance_valid(current_item):
        return null
    return current_item.get_next_in_tree()

func _get_prev_section() -> TreeItem:
    var current_item: TreeItem = _get_current_section()
    if !is_instance_valid(current_item):
        return null
    return current_item.get_prev_in_tree()

func _play_next_section() -> void:
    var next_section: TreeItem = _get_next_section()
    if !is_instance_valid(next_section):
        return
    _play_section(next_section)

func _play_prev_section() -> void:
    var prev_section: TreeItem = _get_prev_section()
    if !is_instance_valid(prev_section):
        return
    _play_section(prev_section)

func _slider_value_selected(seconds: float) -> void:
    print("Seeking to " + str(seconds))
    stopwatch.stop()
    var group: GroupController = find_group_by_timestamp.call(seconds)
    if !is_instance_valid(group):
        stopwatch.resume()
        return
    var slide: SlideNode = group.get_parent() as SlideNode
    _play_section(slide.tree_item)

#endregion

#region Speed Controls

@onready var speed_slider: HSlider = %SpeedSlider
@onready var speed_button: TextureButton = %SpeedButton
@onready var pitch_shift: AudioEffectPitchShift = AudioServer.get_bus_effect(AudioServer.get_bus_index(&"AudioWidget"), 0)

func _speed_slider_value_selected(value: float) -> void:
    Engine.time_scale = value
    get_tree().call_group(&"speed_scale_handler", &"set_speed_scale", value)
    AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index(&"AudioWidget"), 0, not is_equal_approx(value, 1.0))
    pitch_shift.pitch_scale = 1.0 / value

#endregion

#region UI

@onready var fullscreen_button: Button = %FullscreenButton
@onready var center_camera_button: Button = %RecenterCameraButton
@onready var enter_fullscreen_icon: Texture2D = get_theme_icon("enter", fullscreen_button.theme_type_variation)
@onready var exit_fullscreen_icon: Texture2D = get_theme_icon("exit", fullscreen_button.theme_type_variation)
@onready var panels: Array[Control] = [%LeftPanel, %BottomPanel, %RightPanel]
@onready var panel_visible: Array[bool] = [panels[0].visible, panels[1].visible, panels[2].visible]

func _toggle_fullscreen(toggled_on: bool) -> void:
    for i in panels.size():
        panels[i].visible = not toggled_on and panel_visible[i]
    fullscreen_button.icon = exit_fullscreen_icon if toggled_on else enter_fullscreen_icon

func _toggle_camera_button(user_controlled_camera: bool) -> void:
    center_camera_button.visible = user_controlled_camera

#endregion

func _ready():
    if !is_instance_valid(ClassUI.context):
        printerr("ClassUI context is not valid")
    else:
        ClassUI.context.stopwatch = stopwatch
        ClassUI.context.camera.user_controlled_changed.connect(_toggle_camera_button)
    fullscreen_button.toggled.connect(_toggle_fullscreen)
    center_camera_button.pressed.connect(func (): ClassUI.context.camera.user_controlled = false)
    play_button.pressed.connect(_toggle_playback)
    prev_button.pressed.connect(_play_prev_section)
    next_button.pressed.connect(_play_next_section)
    time_slider.value_selected.connect(_slider_value_selected)
    zoom_slider.value_changed.connect(_zoom_slider_value_selected)
    zoom_button.pressed.connect(_zoom_reset)
    speed_button.pressed.connect(func (): speed_slider.value = 1.0)
    speed_slider.value_changed.connect(_speed_slider_value_selected)

func _process(_delta: float):
    time_slider.change_value(stopwatch.running_time)
    current_time_label.text = _get_time_string(floori(stopwatch.running_time))
    _update_zoom_slider_value()
