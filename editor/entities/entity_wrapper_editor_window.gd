extends Window

@export var entity_wrapper: EntityWrapper:
    set(value):
        entity_wrapper = value
        _update_preview()
        _update_properties()

func _update_properties():
    pass

func _update_preview():
    var preview := %PreviewWhiteboard as Node2D
    for child in preview.get_children():
        preview.remove_child(child)
        child.queue_free()
    if not is_instance_valid(entity_wrapper):
        return
    var widget := _instantiate_entity(entity_wrapper, entity_wrapper.entity)
    if widget == null:
        return
    preview.add_child(widget)
    var duration := widget.compute_duration()
    if is_zero_approx(duration):
        duration = 5.0
    widget.animation_finished.connect(_replay.bind(widget, duration))
    widget.play(duration)

func _replay(widget: Widget, duration: float):
    await get_tree().create_timer(1.0).timeout
    if not is_instance_valid(widget):
        return
    widget.play(duration)
    

#region Widget instantiation

func _instantiate_entity(wrapper: EntityWrapper, entity: Entity) -> Widget:
    if !_has_widget(entity):
        push_error("Error instantiating entity: " + entity.get_class_name() + ", widget not found")
        return null
    var widget: Widget = _get_widget(entity)
    widget.entity = entity
    widget.init(wrapper.get_properties())
    return widget

func _has_widget(entity: Entity) -> bool:
    var _class: String = entity.get_class_name().replace("Entity", "Widget")
    return CustomClassDB.class_exists(_class)

func _get_widget(entity: Entity) -> Widget:
    var _class: String = entity.get_class_name().replace("Entity", "Widget")
    return CustomClassDB.instantiate(_class)

#endregion
