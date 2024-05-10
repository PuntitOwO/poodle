class_name EntityEditor
extends Control

@export var sections: Array[ClassSection] = []
@export var entities: Array[Entity] = []

var selected_section: TreeItem

func _ready():
    (%SectionTree as Tree).item_selected.connect(on_section_selected)

func on_class_index_changed(index: ClassIndex):
    sections = index.sections
    entities = index.entities
    _update_section_tree.call_deferred()
    _update_entities_tree.call_deferred()

#region Section Tree

func _update_section_tree():
    var tree := %SectionTree as Tree
    tree.clear()
    tree.create_item()
    for section in sections:
        var section_item = tree.create_item()
        section_item.set_text(0, section.name)
        section_item.set_selectable(0, false)
        _add_slides(section_item, section.slides)

func _add_slides(section: TreeItem, slides: Array[ClassSlide]):
    for slide in slides:
        var slide_item = section.create_child()
        slide_item.set_text(0, slide.name)
        slide_item.set_metadata(0, slide.content_root)

#endregion

#region Slide content Tree

func on_section_selected():
    selected_section = (%SectionTree as Tree).get_selected()
    (%SlideTreeWrapper as TabContainer).current_tab = 1
    _update_slide_tree.call_deferred()

func _update_slide_tree():
    var tree := %SlideTree as Tree
    tree.clear()
    var content_root := selected_section.get_metadata(0) as ClassGroup
    var root := tree.create_item()
    root.set_text(0, content_root.get_editor_name())
    _add_groups(root, content_root.groups)
    _add_entities(root, content_root.entities)

func _add_groups(parent: TreeItem, groups: Array[ClassGroup]):
    for group in groups:
        var group_item = parent.create_child()
        group_item.set_text(0, group.get_editor_name())
        group_item.set_metadata(0, group)
        _add_groups(group_item, group.groups)
        _add_entities(group_item, group.entities)

func _add_entities(parent: TreeItem, _entities: Array[EntityWrapper]):
    for entity in _entities:
        var entity_item = parent.create_child()
        entity_item.set_text(0, "EntityWrapper")
        entity_item.set_metadata(0, entity)

#endregion

#region Entity Tree

func _update_entities_tree():
    var tree := %EntityTree as Tree
    tree.clear()
    var root := tree.create_item()
    var types := _get_type_list()
    for type in types:
        var entity_type := tree.create_item()
        entity_type.set_text(0, type)
        entity_type.set_selectable(0, false)
    for entity in entities:
        var entity_type := entity.get_class_name()
        var type_index := types.find(entity_type)
        if type_index == -1:
            printerr("Entity type not found: " + entity_type)
            continue
        var type_item := root.get_child(type_index)
        var entity_item := type_item.create_child()
        entity_item.set_text(0, entity.get_editor_name())
        entity_item.set_metadata(0, entity)

func _get_type_list() -> PackedStringArray:
    var types := PackedStringArray()
    for entity in entities:
        var type := entity.get_class_name()
        if not types.has(type):
            types.push_back(type)
    return types

#endregion