class_name CustomClassDB
extends Object

## This class is a helper class for custom classes.
##
## It is used to store the classes info to expose an API similar to the [ClassDB] API.

static var classes: Dictionary = {}

static func _static_init():
    _update_classes()

## Returns the names of all the custom classes available.
static func get_class_list() -> Array:
    var classes_keys: Array = classes.keys()
    classes_keys.sort()
    return classes_keys

## Returns whether the specified class is available or not.
static func class_exists(_class: StringName) -> bool:
    return classes.has(_class)

## Creates an instance of the class.
## This method is similar to [method ClassDB.instantiate].
## This method does not check if the class exists or not,
## so it is recommended to use [method class_exists] before calling this method.
static func instantiate(_class: StringName) -> Variant:
    return load(classes[_class].path).new()

static func _update_classes():
    classes.clear()
    var class_list: Array[Dictionary] = ProjectSettings.get_global_class_list()
    for class_info in class_list:
        classes[class_info["class"]] = class_info