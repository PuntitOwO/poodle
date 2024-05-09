@tool
class_name Entity
extends Resource

## Base class for Entity types

## Returns the name of the class.
func get_class_name() -> String:
	return "Entity"

## Returns the name of this entity.
func get_editor_name() -> String:
	return "Unnamed entity"

## Returns a dictionary representation of this entity.
func serialize() -> Dictionary:
	return {
		"entity_type": get_class_name()
	}

## Returns a new instance of this entity type from the given dictionary.
static func deserialize(data: Dictionary) -> Entity:
	assert(CustomClassDB.class_exists(data["entity_type"]), "Entity type does not exist: " + data["entity_type"])
	var instance = CustomClassDB.instantiate(data["entity_type"])
	instance.load_data(data)
	return instance

## Loads data from a dictionary into this entity.
func load_data(_data: Dictionary) -> void:
	pass
