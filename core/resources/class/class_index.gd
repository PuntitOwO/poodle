@tool
# 1. class name: fill the class name
class_name ClassIndex
extends Resource

# 2. docs: use docstring (##) to generate docs for this file
## The main file of a class index

# 3. signals: define signals here

# 4. enums: define enums here

# 5. constants: define constants here

# 6. export variables: define all export variables in groups here
@export var metadata: ClassMetadata
@export var entities: Array[Entity]
@export var sections: Array[ClassSection]
# 7. public variables: define all public variables here

# 8. private variables: define all private variables here, use _ as preffix

# 9. onready variables: define all onready variables here


# 10. init virtual methods: define _init, _enter_tree and _ready mothods here

# 11. virtual methods: define other virtual methos here

# 12. public methods: define all public methods here

func serialize() -> Dictionary:
    var data = {
        "metadata": metadata.serialize(),
        "entities": entities.map(func(e): return e.serialize()),
        "sections": sections.map(func(e): return e.serialize()),
    }
    return data

static func deserialize(data: Dictionary) -> ClassIndex:
    var instance = ClassIndex.new()
    instance.metadata = ClassMetadata.deserialize(data["metadata"])
    instance.entities = []
    for entity in data["entities"]:
        instance.entities.append(Entity.deserialize(entity))
    instance.sections = []
    for section in data["sections"]:
        instance.sections.append(ClassSection.deserialize(section))
    return instance

# 13. private methods: define all private methods here, use _ as preffix

# 14. subclasses: define all subclasses here
