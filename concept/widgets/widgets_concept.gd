extends Node2D

@export var entities: Array[Entity] = []
@export var entity_wrappers: Array[EntityWrapper] = []

func _ready():
    init()

func init():
    for wrapper in entity_wrappers:
        var entity: Entity = entities[wrapper.entity_id]
        var widget: Widget = _get_widget(entity)
        add_child(widget)
        widget.entity = entity
        widget.init(wrapper.get_properties())
    
    _play()

func _play():
    await get_tree().create_timer(3.0).timeout
    var duration: float = get_child(0).get_duration()
    propagate_call("play", [duration])

func _get_widget(entity: Entity) -> Widget:
    var _class: String = entity.get_class_name().replace("Entity", "Widget")
    return CustomClassDB.instantiate(_class)