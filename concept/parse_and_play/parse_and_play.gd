class_name ConceptClassScene
extends Node2D

@export_file() var file: String
@export var class_index: ClassIndex
var entities: Array

@onready var root: Node2D = $Class

var content_root: GroupController
var total_duration: float

var section_manager: SectionManager

func _ready():
	if !_parse():
		push_error("Error parsing file: " + file)
		return
	if !_instantiate():
		push_error("Error instantiating class: " + class_index.name)
		return

func _parse() -> bool:
	if file == null:
		return false
	class_index = load(file)
	return class_index != null

func _instantiate() -> bool:
	section_manager = SectionManager.new()
	entities = class_index.entities
	for section in class_index.sections:
		var node: Node2D = _instantiate_section(section)
		root.add_child(node)
	return true

func _instantiate_section(section: ClassSection) -> Node2D:
	var node: Node2D = Node2D.new()
	var section_tree_item := section_manager.register_section(section.name)
	for slide in section.slides:
		var slide_node: Node2D = _instantiate_slide(slide)
		var slide_tree_item := section_manager.register_slide(section_tree_item, slide_node.name)
		slide_tree_item.set_metadata(0, slide_node)
		node.add_child(slide_node)
	section_tree_item.set_metadata(0, node.get_child(0))
	return node

func _instantiate_slide(slide: ClassSlide) -> Node2D:
	var node: Node2D = Node2D.new()
	node.name = slide.name
	var group: GroupController = GroupController.instantiate(slide.content_root, entities)
	if !is_instance_valid(content_root):
		content_root = group
	node.add_child(group)
	return node

func compute_duration() -> void:
	total_duration = 0.0
	for section in root.get_children():
		for slide in section.get_children():
			total_duration += (slide.get_child(0) as GroupController).compute_duration()

func play():
	if !is_instance_valid(content_root):
		push_error("Error playing content: content_root is not valid")
		return
	content_root.play(total_duration)