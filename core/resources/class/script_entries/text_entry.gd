@tool
class_name TextEntry
extends ScriptEntry

## A [ScriptEntry] that represents a text
const ENTRY_TYPE = "text"

func serialize() -> Dictionary:
    var data = super.serialize()
    data["type"] = ENTRY_TYPE
    return data