@tool
class_name Entity
extends Resource

## Base class for EntityResource types
func get_class_name() -> String:
    return "Entity"

func serialize() -> Dictionary:
    return {
        "entity_type": get_class_name()
    }

static func deserialize(data: Dictionary) -> Entity:
    var instance = ClassDB.instantiate(data["entity_type"])
    instance.deserialize(data)
    return instance