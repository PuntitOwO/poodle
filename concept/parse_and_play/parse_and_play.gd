extends Node2D

@export_file() var file: String
@export var class_index: ClassIndex
var entities: Array

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
	var group: Node2D = _instantiate_group(slide.content_root)
	node.add_child(group)
	return node

func _instantiate_group(group: ClassGroup) -> Node2D:
	var node: Node2D = Node2D.new()
	for entity in group.entities:
		var entity_node: Widget = _instantiate_entity(entity)
		node.add_child(entity_node)
	for child_group in group.groups:
		var child_group_node: Node2D = _instantiate_group(child_group)
		node.add_child(child_group_node)
	return node

func _instantiate_entity(wrapper: EntityWrapper) -> Widget:
	var entity: Entity = entities[wrapper.entity_id]
	if !_has_widget(entity):
		push_error("Error instantiating entity: " + entity.get_class_name() + ", widget not found")
		return Widget.new()
	var widget: Widget = _get_widget(entity)
	widget.entity = entity
	widget.init(wrapper.get_properties())
	return widget

func _has_widget(entity: Entity) -> bool:
	var _class: String = entity.get_class_name().replace("Entity", "Widget")
	return CustomClassDB.class_exists(_class)

func _get_widget(entity: Entity) -> Widget:
	var _class: String = entity.get_class_name().replace("Entity", "Widget")
	return CustomClassDB.instantiate(_class)
