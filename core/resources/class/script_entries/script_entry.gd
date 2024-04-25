@tool
# 1. class name: fill the class name
class_name ScriptEntry
extends Resource

# 2. docs: use docstring (##) to generate docs for this file
## A base class for a script entry
##
## See also:
## * [TextEntry] for a text entry
## * [CommentEntry] for a comment entry
## * [AltTextEntry] for an alternative text entry

# 3. signals: define signals here

# 4. enums: define enums here

# 5. constants: define constants here

# 6. export variables: define all export variables in groups here
@export var content: String
# 7. public variables: define all public variables here

# 8. private variables: define all private variables here, use _ as preffix

# 9. onready variables: define all onready variables here


# 10. init virtual methods: define _init, _enter_tree and _ready mothods here

# 11. virtual methods: define other virtual methos here

# 12. public methods: define all public methods here
func get_class_name() -> String:
    return "ScriptEntry"

func serialize() -> Dictionary:
    return {
        "entry_type": get_class_name(),
        "content": content,
    }

static func deserialize(data: Dictionary) -> ScriptEntry:
    var instance: ScriptEntry = CustomClassDB.instantiate(data["entry_type"])
    instance.content = data["content"]
    instance.load_data(data)
    return instance

func load_data(_data: Dictionary) -> void:
    pass
# 13. private methods: define all private methods here, use _ as preffix

# 14. subclasses: define all subclasses here
