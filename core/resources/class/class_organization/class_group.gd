@tool
# 1. class name: fill the class name
class_name ClassGroup
extends Resource

# 2. docs: use docstring (##) to generate docs for this file
## Base class for a resource that represents a group of [Entity]s or [ClassGroup]s.
## See also:
##   * [ClassChainGroup], a group that is executed in sequence.
##   * [ClassParallelGroup], a group that is executed in parallel.

# 3. signals: define signals here

# 4. enums: define enums here
enum GROUP_STATE { 
    EMPTY, 
    ENTITY, 
    GROUP, 
}
# 5. constants: define constants here

# 6. export variables: define all export variables in groups here
@export var entities: Array[EntityWrapper] = []:
    set(value):
        entities = value
        _validate()

@export var groups: Array[ClassGroup] = []:
    set(value):
        groups = value
        _validate()

# 7. public variables: define all public variables here
var state: GROUP_STATE = GROUP_STATE.EMPTY:
    get:
        if not entities.is_empty():
            return GROUP_STATE.ENTITY
        if not groups.is_empty():
            return GROUP_STATE.GROUP
        return GROUP_STATE.EMPTY
# 8. private variables: define all private variables here, use _ as preffix

# 9. onready variables: define all onready variables here


# 10. init virtual methods: define _init, _enter_tree and _ready mothods here

# 11. virtual methods: define other virtual methos here

# 12. public methods: define all public methods here
func get_class_name() -> String:
    return "ClassGroup"

func get_editor_name() -> String:
    if not entities.is_empty():
        return "group: %d entities" % len(entities)
    if not groups.is_empty():
        return "group: %d groups" % len(groups)
    return "group: Empty"

func serialize() -> Dictionary:
    var serialized: Dictionary = {
        "entities": entities.map(func(e): return e.serialize()),
        "groups": groups.map(func(g): return g.serialize()),
        "group_type": get_class_name(),
    }
    return serialized

static func deserialize(data: Dictionary) -> ClassGroup:
    var instance: ClassGroup = CustomClassDB.instantiate(data["group_type"])
    for entity in data["entities"]:
        instance.entities.append(EntityWrapper.deserialize(entity))
    for group in data["groups"]:
        instance.groups.append(ClassGroup.deserialize(group))
    instance.load_data(data)
    return instance

# 13. private methods: define all private methods here, use _ as preffix
func _validate():
    var null_group: bool = groups == null
    var null_entity: bool = entities == null
    if null_group or null_entity:
        return
    if len(entities) > 0 and len(groups) > 0:
        push_error("Error: One of entites or groups must be empty.")
# 14. subclasses: define all subclasses here
