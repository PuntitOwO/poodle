# 1. class name: fill the class name
class_name ClassChainGroup
extends ClassGroup

# 2. docs: use docstring (##) to generate docs for this file
## A resource that represents a group of [Entity]s that will play one after the other

# 3. signals: define signals here

# 4. enums: define enums here

# 5. constants: define constants here
const GROUP_TYPE = "chain"

# 6. export variables: define all export variables in groups here

# 7. public variables: define all public variables here

# 8. private variables: define all private variables here, use _ as preffix

# 9. onready variables: define all onready variables here


# 10. init virtual methods: define _init, _enter_tree and _ready mothods here

# 11. virtual methods: define other virtual methos here

# 12. public methods: define all public methods here

func serialize() -> Dictionary:
    var serialized = super.serialize()
    serialized["type"] = "chain"
    return serialized

# 13. private methods: define all private methods here, use _ as preffix

# 14. subclasses: define all subclasses here
