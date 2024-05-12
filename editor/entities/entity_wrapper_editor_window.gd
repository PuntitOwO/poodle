extends Window

@export var entity_wrapper: EntityWrapper:
    set(value):
        entity_wrapper = value
        _update_preview()
        _update_properties()

func _ready():
    (%RefreshButton as Button).pressed.connect(_update_preview)

func _update_properties():
    var prop_list := %PropertyEditor as Control
    for child in prop_list.get_children():
        prop_list.remove_child(child)
        child.queue_free()
    if not is_instance_valid(entity_wrapper):
        return
    var prop_types := CustomClassDB.get_inheriters_from_class(&"EntityProperty")
    for prop in entity_wrapper.entity_properties:
        var index := prop_types.find(prop.get_class_name())
        prop_types.remove_at(index)
        # TODO: add property to the property editor
        var container := HBoxContainer.new()
        var label := Label.new()
        label.text = prop.get_class_name()
        container.add_child(label)
        var button := Button.new()
        button.text = "Remove"
        button.pressed.connect(_remove_property.bind(prop))
        container.add_child(button)
        %PropertyEditor.add_child(container)
    for prop_type in prop_types:
        var button := Button.new()
        button.text = "Add " + prop_type
        button.pressed.connect(_add_property.bind(prop_type))
        %PropertyEditor.add_child(button)

func _add_property(prop_type: String):
    var prop := CustomClassDB.instantiate(prop_type) as EntityProperty
    entity_wrapper.entity_properties.append(prop)
    _update_properties()
    _update_preview()

func _remove_property(prop: EntityProperty):
    entity_wrapper.entity_properties.erase(prop)
    _update_properties()
    _update_preview()

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
