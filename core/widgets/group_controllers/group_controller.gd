class_name GroupController
extends Node2D

## Called to compute the total duration of the animations in this group.
func compute_duration() -> float:
    return 0.0

## Called when it's time to play the widgets in this group.
## The animation should be played for the given [param duration].
func play(_duration: float) -> void:
    pass

## Called when the player seeked to a point before this group was played.
## The widgets should be reset to its initial state.
func reset() -> void:
    pass

static func instantiate(group: ClassGroup, entities: Array[Entity]) -> GroupController:
    var _class: String = group.get_class_name().replace("Class", "") + "Controller"
    assert(CustomClassDB.class_exists(_class), "Class " + _class + " does not exist.")
    var controller: GroupController = CustomClassDB.instantiate(_class)
    controller.load_data(group, entities)
    return controller

func load_data(group: ClassGroup, entities: Array[Entity]) -> void:
    for entity in group.entities:
        var entity_node: Widget = _instantiate_entity(entity, entities)
        add_child(entity_node)
    for child_group in group.groups:
        var child_group_node: Node2D = GroupController.instantiate(child_group, entities)
        add_child(child_group_node)

func _instantiate_entity(wrapper: EntityWrapper, entities: Array[Entity]) -> Widget:
    var entity: Entity = entities[wrapper.entity_id]
    if !_has_widget(entity):
        push_error("Error instantiating entity: " + entity.get_class_name() + ", widget not found")
        return Widget.new()
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
