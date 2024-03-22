@tool
class_name ClassIndexResourceLoader
extends ResourceFormatLoader

## ClassIndexResourceLoader is a custom resource loader for [ClassIndex] resources.
## It loads a JSON file and deserializes it into a [ClassIndex] resource.

## Returns the list of extensions available for loading the resource.
## In this case, only json.
func _get_recognized_extensions() -> PackedStringArray:
	return PackedStringArray(["ito"])

## Returns the resource type that this loader can handle.
## In this case, only custom resources that are a subclass of [Resource].
func _get_resource_type(_path: String) -> String:
	return "Resource"

## Returns the class name of the script that will be created when loading the resource.
## In this case, [ClassIndex].
func _get_resource_script_class(_path: String) -> String:
	return "ClassIndex"

## Returns whether the resource type is handled by this loader.
## In this case, only custom resources that are a subclass of [Resource].
func _handles_type(type: StringName) -> bool:
	return ClassDB.is_parent_class(type, "Resource")

## Loads the resource from the given file.
## In this case, it reads the JSON file and deserializes it into a [ClassIndex] resource.
## Returns an [ClassIndex] resource on success, or an error code on failure.
## Only path parameter is currently used, other parameters are not used.
func _load(path: String, _original_path: String, _use_sub_threads: bool, _cache_mode: int):
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return FileAccess.get_open_error()
	
	var raw_json: String = file.get_as_text()
	file.close()

	var json: JSON = JSON.new()
	var error: int = json.parse(raw_json)
	if error != OK:
		return error
	if typeof(json.data) != TYPE_DICTIONARY:
		return ERR_INVALID_DATA
	
	var class_index: ClassIndex = ClassIndex.deserialize(json.data)
	return class_index
