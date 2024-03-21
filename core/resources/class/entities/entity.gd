@tool
class_name Entity
extends Resource

## Base class for EntityResource types
func get_class_name() -> String:
    return "Entity"

func serialize():
    push_error("Entity.serialize() not implemented")