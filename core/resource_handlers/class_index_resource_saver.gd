@tool
class_name ClassIndexResourceSaver
extends ResourceFormatSaver

## ClassIndexResourceSaver is a custom resource saver for [ClassIndex] resources.
## It saves the resource to a JSON file.

## Returns the list of extensions available for saving the resource,
## in this case, only json.
func _get_recognized_extensions(_resource: Resource) -> PackedStringArray:
    return PackedStringArray(["ito"])

## Returns whether the resource can be saved by this saver.
## In this case, only [ClassIndex] resources can be saved.
func _recognize(resource: Resource) -> bool:
    return resource is ClassIndex

## Saves the resource to a file at the given path.
## In this case, the resource is serialized to JSON and saved to the file.
## Returns @GlobalScope.OK on success, or an error code on failure.
## The flags are currently unused.
func _save(resource: Resource, path: String, _flags: int):
    if not (resource is ClassIndex):
        return ERR_INVALID_DATA
    
    var data: Dictionary = resource.serialize()
    var json: String = JSON.stringify(data, "\t")

    var file: FileAccess = FileAccess.open(path, FileAccess.WRITE)
    if file == null:
        return FileAccess.get_open_error()
    
    file.store_string(json)
    file.close()
    return OK