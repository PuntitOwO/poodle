class_name EntityEditor
extends Control

@export var sections: Array[ClassSection] = []
@export var entities: Array[Entity] = []

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