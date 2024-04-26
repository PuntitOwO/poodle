extends Control

const SQUARED_THRESHOLD = 25.0

var pressed = false:
    set(value):
        pressed = value
        Input.use_accumulated_input = not value
var line: Line2D
var last_point := Vector2.INF
var entities: Array[LineEntity] = []

func _input(event):
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
        entities.append(_generate_entity(line))
        %ItemList.add_item("Line " + str(entities.size()), thumbnail)
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
    var screenshot_rect := Rect2i(Vector2i(Vector2(l, t)) * ratio, Vector2i(Vector2(r, b)) * ratio)
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


func _generate_entity(node: Line2D) -> LineEntity:
    var entity = LineEntity.new()
    entity.points = node.points
    return entity
