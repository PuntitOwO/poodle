@tool
class_name CommentEntry
extends ScriptEntry

## A [ScriptEntry] that represents a comment
func get_class_name() -> String:
    return "CommentEntry"

func serialize() -> Dictionary:
    var data = super.serialize()
    data["entity_type"] = get_class_name()
    return data