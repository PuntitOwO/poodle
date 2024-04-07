class_name ConceptClassWindow
extends Control

#region Section Tree
@onready var section_tree_parent: Control = %Sections

func set_section_tree(tree: Tree) -> void:
    section_tree_parent.add_child(tree)
    tree.item_activated.connect(_on_tree_section_clicked.bind(tree))

func _on_tree_section_clicked(tree: Tree) -> void:
    var selected: TreeItem = tree.get_selected()
    if selected == null:
        return
    var section: Node2D = selected.get_metadata(0)
    if !is_instance_valid(section):
        return
    print("Section clicked: ", section)
    

#endregion

#region Whiteboard
@onready var whiteboard: SubViewport = %SubViewport

func set_class_node(node: Node) -> void:
    node.reparent(whiteboard)
#endregion

#region Playback
@onready var current_time_label: Label = %CurrentTimeLabel
@onready var time_slider: HSlider = %TimeSlider
@onready var total_time_label: Label = %TotalTimeLabel

func set_total_time(total_time: int) -> void:
    var total_time_string := _get_time_string(total_time)
    total_time_label.text = total_time_string

func _get_time_string(time: int) -> String:
    var minutes := time / 60
    var seconds := time % 60
    return str(minutes).lpad(2, "0") + ":" + str(seconds).lpad(2, "0")
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

#endregion

func _ready():
    play_button.pressed.connect(_toggle_playback)