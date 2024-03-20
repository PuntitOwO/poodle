@tool
# 1. class name: fill the class name
class_name ClassSection
extends Resource

# 2. docs: use docstring (##) to generate docs for this file
## A resource that represents a section of a class

# 3. signals: define signals here

# 4. enums: define enums here

# 5. constants: define constants here

# 6. export variables: define all export variables in groups here
@export var name: String
@export var slides: Array[ClassSlide]
# 7. public variables: define all public variables here

# 8. private variables: define all private variables here, use _ as preffix

# 9. onready variables: define all onready variables here


# 10. init virtual methods: define _init, _enter_tree and _ready mothods here

# 11. virtual methods: define other virtual methos here

# 12. public methods: define all public methods here

func serialize() -> Dictionary:
    return {
        "name": name,
        "slides": slides.map(func(slide): slide.serialize()),
    }

# 13. private methods: define all private methods here, use _ as preffix

# 14. subclasses: define all subclasses here
