class_name SlideNode
extends IndexedNode2D

## An [IndexedNode2D] that represents a [ClassSlide] in the node class structure.

var absolute_slide_id: int = -1

static var hide_on_finished: bool = false
const SCREEN_SIZE: Vector2 = Vector2(1080, 720)

func _ready():
    var notifier := VisibleOnScreenNotifier2D.new()
    notifier.rect = Rect2(Vector2(0, 0), SCREEN_SIZE)
    add_child(notifier, false, INTERNAL_MODE_FRONT)
    var root := get_child(0) as GroupController
    notifier.screen_entered.connect(root.show)
    notifier.screen_exited.connect(root.hide)
    add_to_group("slide_nodes")

## Passes the play call to the first child node.
func play() -> void:
    show()
    add_to_group("current_slide")
    var root: GroupController = get_child(0) as GroupController
    if !root.animation_finished.is_connected(on_slide_finished):
        root.animation_finished.connect(on_slide_finished)
    current = true
    root.play()

## Called when the slide has finished playing.
## If the next slide is valid, it will be played.
func on_slide_finished() -> void:
    current = false
    remove_from_group("current_slide")
    if !is_instance_valid(tree_item):
        return
    var next_item: TreeItem = tree_item.get_next_in_tree()
    if !is_instance_valid(next_item):
        return
    var next: SlideNode = next_item.get_metadata(0) as SlideNode
    if !is_instance_valid(next):
        return
    next.play()
    if hide_on_finished:
        hide()

## Called when a slide has been seeked to.
func on_seek(prev_slide_id: int, new_slide_id: int) -> void:
    # If the slide is outside the range of the previous slide and the new slide,
    # there is no need to do anything.
    if _outside_slide_range(prev_slide_id, new_slide_id):
        return
    if new_slide_id > absolute_slide_id:
        skip_to_end()
    else:
        skip_to_start()

func skip_to_end() -> void:
    stop()
    var root: GroupController = get_child(0) as GroupController
    root.skip_to_end()

func skip_to_start() -> void:
    stop()
    var root: GroupController = get_child(0) as GroupController
    root.reset()

func stop() -> void:
    var root: GroupController = get_child(0) as GroupController
    if root.animation_finished.is_connected(on_slide_finished):
        root.animation_finished.disconnect(on_slide_finished)
    remove_from_group("current_slide")
    current = false
    # root.reset()
    # hide()

## Returns whether this slide is outside the range of the previous slide and the new slide.
func _outside_slide_range(prev_slide_id: int, new_slide_id: int) -> bool:
    return absolute_slide_id < mini(prev_slide_id, new_slide_id) or absolute_slide_id > maxi(prev_slide_id, new_slide_id)