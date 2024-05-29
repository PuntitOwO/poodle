class_name ExampleEntityProperty
extends EntityProperty

@export var color: Color

func get_property() -> Dictionary:
    return {"color": color}

func get_class_name() -> String:
    return "ExampleEntityProperty"

func serialize() -> Dictionary:
    var data: Dictionary = super.serialize()
    data["color"] = color.to_html()
    return data

func load_data(data: Dictionary):
    super.load_data(data)
    color = Color.html(data["color"])