class_name ConceptClassWindow
extends Control

#region Section Tree
@onready var section_tree_parent: Control = %Sections

func set_section_tree(tree: Tree) -> void:
    section_tree_parent.add_child(tree)
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