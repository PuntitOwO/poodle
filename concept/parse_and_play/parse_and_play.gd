extends Node2D

@export_file() var file: String
@export var class_index: ClassIndex
var entities: Array

var content_root: GroupController

func _ready():
	if !_parse():
		push_error("Error parsing file: " + file)
		return
	if !_instantiate():
		push_error("Error instantiating class: " + class_index.name)
		return
	_play()

func _parse() -> bool:
	if file == null:
		return false
	class_index = load(file)
	return class_index != null

func _instantiate() -> bool:
	entities = class_index.entities
	for section in class_index.sections:
		var node: Node2D = _instantiate_section(section)
		add_child(node)
	return true

func _instantiate_section(section: ClassSection) -> Node2D:
	var node: Node2D = Node2D.new()
	node.name = section.name
	for slide in section.slides:
		var slide_node: Node2D = _instantiate_slide(slide)
		node.add_child(slide_node)
	return node

func _instantiate_slide(slide: ClassSlide) -> Node2D:
	var node: Node2D = Node2D.new()
	node.name = slide.name
	var group: GroupController = GroupController.instantiate(slide.content_root, entities)
	if !is_instance_valid(content_root):
		content_root = group
	node.add_child(group)
	return node

func _play():
	if !is_instance_valid(content_root):
		push_error("Error playing content: content_root is not valid")
		return
	var duration: float = content_root.compute_duration()
	content_root.play(duration)