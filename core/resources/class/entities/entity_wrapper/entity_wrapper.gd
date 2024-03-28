class_name EntityWrapper
extends Resource

@export var entity_id: int = 0

@export var entity_properties: Array[EntityProperty] = []

var entity: Entity = null

## Return a dictionary with all the properties of the entity.
## Keys with the same name will be overwritten.
func get_properties() -> Dictionary:
	var _properties: Dictionary = {}
	for property in entity_properties:
		var _prop: Dictionary = property.get_property()
		_properties.merge(_prop, true)
	return _properties

func serialize() -> Dictionary:
	return {
		"entity_id": entity_id,
		"entity_properties": entity_properties.map(func(p): return p.serialize()),
	}

static func deserialize(data: Dictionary) -> EntityWrapper:
	var instance: EntityWrapper = EntityWrapper.new()
	instance.entity_id = data["entity_id"]
	for property_data in data["entity_properties"]:
		instance.entity_properties.append(EntityProperty.deserialize(property_data))
	return instance