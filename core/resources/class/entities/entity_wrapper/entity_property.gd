@tool
class_name EntityProperty
extends Resource

## Returns the property of the entity.
func get_property() -> Dictionary:
    return {}

func get_class_name() -> String:
    return "EntityProperty"

func serialize() -> Dictionary:
    return {
        "property_type": get_class_name(),
    }

static func deserialize(data: Dictionary) -> EntityProperty:
    assert(CustomClassDB.class_exists(data["property_type"]), "EntityProperty type does not exist: " + data["property_type"])
    var instance = CustomClassDB.instantiate(data["property_type"])
    instance.load_data(data)
    return instance

func load_data(_data: Dictionary) -> void:
    pass
