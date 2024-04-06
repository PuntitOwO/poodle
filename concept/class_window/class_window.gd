class_name ConceptClassWindow
extends Control

#region Section Tree
@onready var section_tree: Tree = %Tree

var counter: Array[int] = []
var depth: int = -1:
    set(value):
        depth = value
        counter.resize(depth + 1)

func reset() -> void:
    section_tree.clear()
    depth = -1
    counter = []

func register_section(section_name: String) -> TreeItem:
    if depth < 0:
        depth = 0
    var numbering := _get_numbering(0)
    var section := section_tree.create_item()
    section.set_text(0, numbering + ": " + section_name)
    return section

func register_slide(section: TreeItem, slide_name: String) -> TreeItem:
    if depth < 1:
        depth = 1
    var numbering := _get_numbering(1)
    var slide := section_tree.create_item(section)
    slide.set_text(0, numbering + ": " + slide_name)
    return slide

func register_widget(slide: TreeItem, widget_name: String) -> TreeItem:
    if depth < 2:
        depth = 2
    var numbering := _get_numbering(2)
    var widget := section_tree.create_item(slide)
    widget.set_text(0, numbering + ": " + widget_name)
    return widget

func _get_numbering(level: int) -> String:
    if counter[level] == null:
        counter[level] = 0
    counter[level] += 1
    return '.'.join(PackedStringArray(counter.slice(0, level + 1).map(func(x): str(x))))
#endregion

#region Whiteboard
@onready var whiteboard: SubViewport = %SubViewport

func set_class_node(node: Node) -> void:
    node.reparent(whiteboard)
#endregion