@tool
class_name PositionEntityProperty
extends EntityProperty

@export var position: Vector2

func get_property() -> Dictionary:
    return {"position": position}

func get_class_name() -> String:
    return "PositionEntityProperty"

func serialize() -> Dictionary:
    var data: Dictionary = super.serialize()
    data["position:x"] = position.x
    data["position:y"] = position.y
    return data

func load_data(data: Dictionary):
    super.load_data(data)
    position = Vector2(data["position:x"], data["position:y"])