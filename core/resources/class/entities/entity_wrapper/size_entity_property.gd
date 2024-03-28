@tool
class_name SizeEntityProperty
extends EntityProperty

@export var size: Vector2

func get_property() -> Dictionary:
    return {"size": size}

func get_class_name() -> String:
    return "SizeEntityProperty"

func serialize() -> Dictionary:
    var data: Dictionary = super.serialize()
    data["size:x"] = size.x
    data["size:y"] = size.y
    return data

func load_data(data: Dictionary):
    super.load_data(data)
    size = Vector2(data["size:x"], data["size:y"])