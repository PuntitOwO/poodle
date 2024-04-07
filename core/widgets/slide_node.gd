class_name SlideNode
extends IndexedNode2D

## An [IndexedNode2D] that represents a [ClassSlide] in the node class structure.

## Passes the play call to the first child node.
func play() -> void:
    var root: GroupController = get_child(0) as GroupController
    root.animation_finished.connect(on_slide_finished)
    current = true
    root.play()

## Called when the slide has finished playing.
## If the next slide is valid, it will be played.
func on_slide_finished() -> void:
    current = false
    if !is_instance_valid(tree_item):
        return
    var next_item: TreeItem = tree_item.get_next_in_tree()
    if !is_instance_valid(next_item):
        return
    var next: SlideNode = next_item.get_metadata(0) as SlideNode
    if !is_instance_valid(next):
        return
    next.play()