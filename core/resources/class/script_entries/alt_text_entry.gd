@tool
class_name AltTextEntry
extends ScriptEntry

## A [ScriptEntry] that represents alternative text
const ENTRY_TYPE = "alt_text"

func serialize() -> Dictionary:
    var data = super.serialize()
    data["type"] = ENTRY_TYPE
    return data