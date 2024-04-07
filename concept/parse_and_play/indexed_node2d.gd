class_name IndexedNode2D
extends Node2D

## IndexedNode2D is a [Node2D] that can be indexed in a [Tree].
##
## It holds the reference to the [TreeItem] that points to this node.

var tree_item: TreeItem:
    set(item):
        tree_item = item
        if is_instance_valid(tree_item):
            tree_item.set_metadata(0, self)

var current: bool = false:
    set(value):
        if current == value:
            return
        current = value
        _on_current_changed(current)

var on_current_changed: Callable

func _on_current_changed(value: bool) -> void:
    if is_instance_valid(tree_item):
        tree_item.set_custom_color(0, Color.LIME_GREEN if value else Color.WHITE)
    if is_instance_valid(on_current_changed) and on_current_changed.is_valid():
        on_current_changed.call(value)

