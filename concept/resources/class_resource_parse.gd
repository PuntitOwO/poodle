extends Node

@export_file() var file: String
@export var class_index: ClassIndex

# Called when the node enters the scene tree for the first time.
func _ready():
	if file == null:
		print("File is null")
		return
	class_index = load(file)
	if class_index != null:
		print(class_index)
