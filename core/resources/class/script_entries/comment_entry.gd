@tool
class_name CommentEntry
extends ScriptEntry

## A [ScriptEntry] that represents a comment
const ENTRY_TYPE = "comment"

func serialize() -> Dictionary:
    var data = super.serialize()
    data["type"] = ENTRY_TYPE
    return data