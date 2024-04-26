class_name ConceptClassScene
extends Node2D

var file: String
@export var class_index: ClassIndex
var entities: Array

@onready var root: Node2D = $Class

var zip_file: ZIPReader

var entry_point: SlideNode
var total_duration: float

var section_manager: SectionManager
var slide_count: int = 0

var timestamps: Array[GroupController] = []

func _ready():
	if !_parse():
		push_error("Error parsing file: " + file)
		return
	if !_instantiate():
		push_error("Error instantiating class: " + class_index.name)
		return
	zip_file.close()
	print("parse_and_play._ready")

func _parse() -> bool:
	zip_file = ZIPReader.new()
	if file == null or file.is_empty():
		file = Persistence.class_path
	print("File: " + file)
	if file == null or file.is_empty():
		push_error("Error: file not set")
		return false
	var err := zip_file.open(file)
	if err != OK:
		push_error("Error %d opening file: " % err)
		return false
	if !zip_file.file_exists("index.json"):
		push_error("Error: index.json not found in zip file")
		return false
	var index_string := zip_file.read_file("index.json").get_string_from_utf8()
	var index = JSON.parse_string(index_string)
	if index == null or typeof(index) != TYPE_DICTIONARY:
		return false
	Widget.zip_file = zip_file
	class_index = ClassIndex.deserialize(index)
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
		var slide_node: SlideNode = _instantiate_slide(slide)
		var slide_tree_item := section_manager.register_slide(section_tree_item, slide_node.name)
		slide_node.tree_item = slide_tree_item
		slide_node.absolute_slide_id = slide_count
		slide_count += 1
		node.add_child(slide_node)
	section_tree_item.set_metadata(0, node.get_child(0))
	return node

func _instantiate_slide(slide: ClassSlide) -> SlideNode:
	var node: SlideNode = SlideNode.new()
	node.name = slide.name
	var group: GroupController = GroupController.instantiate(slide.content_root, entities)
	if !is_instance_valid(entry_point):
		entry_point = node
	node.add_child(group)
	return node

func compute_duration() -> void:
	total_duration = 0.0
	for section in root.get_children():
		for slide in section.get_children():
			var group = slide.get_child(0) as GroupController
			group.timestamp = total_duration
			timestamps.append(group)
			total_duration += group.compute_duration()

func play():
	if !is_instance_valid(entry_point):
		push_error("Error playing content: entry_point is not valid")
		return
	entry_point.play()

## Returns the group that contains the given timestamp.
## If the timestamp is not within any group, returns null.
func find_group_by_timestamp(timestamp: float) -> GroupController:
	for group in timestamps:
		if group.timestamp <= timestamp and timestamp < group.timestamp + group.compute_duration():
			return group
	return null