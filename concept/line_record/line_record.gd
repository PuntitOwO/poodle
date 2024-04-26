extends Control

const SQUARED_THRESHOLD = 25.0

var pressed = false:
    set(value):
        pressed = value
        Input.use_accumulated_input = not value
var line: Line2D
var last_point := Vector2.INF
var items: Array[LineItem] = []
var idx: int = 0

func _ready():
    %Remove.pressed.connect(_remove_items)
    %Save.pressed.connect(_save_items)

func _gui_input(event):
    if event is InputEventMouseMotion:
        _handle_mouse(event)

func _handle_mouse(event: InputEventMouseMotion):
    if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
        if not pressed:
            pressed = true
            line = _new_line()
            add_child(line)
            line.add_point(event.global_position)
            last_point = event.global_position
        line.set_point_position(line.get_point_count() - 1, event.global_position)
        if last_point.distance_squared_to(event.global_position) > SQUARED_THRESHOLD:
            line.add_point(event.global_position)
            last_point = event.global_position
    if not event.button_mask & MOUSE_BUTTON_MASK_LEFT and pressed:
        line.add_point(event.global_position)
        pressed = false
        last_point = Vector2.INF
        var thumbnail := _post_process_line(line)
        var item: LineItem = LineItem.new("Line " + str(idx), thumbnail, line)
        items.append(item)
        idx += 1
        %ItemList.add_item(item.name, item.thumbnail)
        line = null

func _new_line() -> Line2D:
    var _line = Line2D.new()
    _line.begin_cap_mode = Line2D.LINE_CAP_ROUND
    _line.end_cap_mode = Line2D.LINE_CAP_ROUND
    _line.joint_mode = Line2D.LINE_JOINT_ROUND
    return _line

func _post_process_line(node: Line2D) -> Texture2D:
    # Get the bounding box of the line
    var l: float = INF;
    var t: float = INF;
    var r: float = -INF;
    var b: float = -INF;
    for i in node.get_point_count():
        var p := node.get_point_position(i)
        l = min(l, p.x)
        t = min(t, p.y)
        r = max(r, p.x)
        b = max(b, p.y)
    # Take a screenshot of the bounding box
    var screenshot := get_viewport().get_texture().get_image()
    # Get screenshot coordinates of the bounding box
    var viewport_size := Vector2i(get_viewport().get_visible_rect().size)
    var screenshot_size := screenshot.get_size()
    var ratio := viewport_size / screenshot_size
    var screenshot_rect := Rect2i(Vector2i(Vector2(l, t)) * ratio, Vector2i(Vector2(r - l, b - t)) * ratio)
    # Crop the screenshot
    screenshot = screenshot.get_region(screenshot_rect)

    # Move the line to the origin
    var line_position := Vector2(l, t)
    for i in node.get_point_count():
        var p := node.get_point_position(i)
        node.set_point_position(i, p - line_position)
    # Move the node to compensate visually for the line movement
    node.position += line_position
    # Create a new texture with the cropped screenshot
    return ImageTexture.create_from_image(screenshot)

func _remove_items() -> void:
    if not %ItemList.is_anything_selected():
        return
    var selected_items: PackedInt32Array = %ItemList.get_selected_items()
    selected_items.reverse()
    for i in selected_items:
        var item: LineItem = items[i]
        item.node.get_parent().remove_child(item.node)
        item.node.queue_free()
        items.remove_at(i)
        %ItemList.remove_item(i)
        item.call_deferred("free")

func _save_items() -> void:
    var entities := items.map(func (i): return i._generate_entity().serialize())
    var json = JSON.stringify(entities, "\t")
    DisplayServer.clipboard_set(json)

class LineItem:
    var thumbnail: Texture2D
    var node: Line2D
    var name: String

    func _init(_name: String, _thumbnail: Texture2D, _node: Line2D):
        thumbnail = _thumbnail
        node = _node
        name = _name

    func _generate_entity() -> LineEntity:
        var entity = LineEntity.new()
        entity.points = node.points
        return entity