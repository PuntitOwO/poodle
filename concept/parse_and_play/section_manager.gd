class_name SectionManager
extends Resource

var tree: Tree

var counter: Array[int] = []
var depth: int = -1:
    set(value):
        depth = value
        counter.resize(depth + 1)

func _init():
    tree = Tree.new()
    tree.hide_root = true
    tree.create_item()

func reset() -> void:
    tree.clear()
    tree.create_item()
    depth = -1
    counter = []

func register_section(section_name: String) -> TreeItem:
    if depth < 0:
        depth = 0
    var numbering := _get_numbering(0)
    var section := tree.create_item()
    section.set_selectable(0, false)
    section.set_text(0, numbering + ": " + section_name)
    return section

func register_slide(section: TreeItem, slide_name: String) -> TreeItem:
    if depth < 1:
        depth = 1
    var numbering := _get_numbering(1)
    var slide := tree.create_item(section)
    slide.set_text(0, numbering + ": " + slide_name)
    return slide

func register_widget(slide: TreeItem, widget_name: String) -> TreeItem:
    if depth < 2:
        depth = 2
    var numbering := _get_numbering(2)
    var widget := tree.create_item(slide)
    widget.set_text(0, numbering + ": " + widget_name)
    return widget

func _get_numbering(level: int) -> String:
    # print("Get numbering for level: " + str(level))
    if counter[level] == null:
        counter[level] = 0
    counter[level] = counter[level] + 1
    depth = level
    # print(counter)
    return '.'.join(PackedStringArray(counter.map(func(x): return str(x))))