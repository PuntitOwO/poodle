@tool
class_name TextEntry
extends ScriptEntry

## A [ScriptEntry] that represents a text
func get_class_name() -> String:
    return "TextEntry"

func serialize() -> Dictionary:
    var data = super.serialize()
    data["entity_type"] = get_class_name()
    return data