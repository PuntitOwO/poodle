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
	assert(CustomClassDB.class_exists(data["entity_type"]), "Entity type does not exist: " + data["entity_type"])
	var instance = CustomClassDB.instantiate(data["entity_type"])
	instance.load_data(data)
	return instance

func load_data(_data: Dictionary) -> void:
	pass
