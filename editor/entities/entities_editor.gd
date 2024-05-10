class_name EntityEditor
extends Control

@export var sections: Array[ClassSection] = []
@export var entities: Array[Entity] = []

var selected_slide: TreeItem
var selected_entity_wrapper: EntityWrapper

func _ready():
    (%SectionTree as Tree).item_selected.connect(on_section_selected)
    (%SlideTree as Tree).item_selected.connect(on_group_selected)
    (%SlideTree as Tree).nothing_selected.connect(on_group_deselected)
    (%EntityTree as Tree).item_selected.connect(func (): (%SetEntityButton as Button).disabled = false)
    (%EntityTree as Tree).nothing_selected.connect(func (): (%SetEntityButton as Button).disabled = true)
    (%EntityWrapperPanel as Control).visible = false
    (%SlideTreeSwitcher as SwitcherContainer).show_second = false
    _configure_groups_dropdown()
    (%AddGroupButton as Button).pressed.connect(_add_new_item_to_group)
    (%RemoveGroupButton as Button).pressed.connect(_remove_item_from_group)
    (%SetEntityButton as Button).pressed.connect(_set_entity)

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
        slide_item.set_metadata(0, slide)

#endregion

#region Slide content Tree

func on_section_selected():
    selected_slide = (%SectionTree as Tree).get_selected()
    (%SlideTreeSwitcher as SwitcherContainer).show_second = true
    _update_slide_tree.call_deferred()

func on_group_selected():
    var selected := (%SlideTree as Tree).get_selected()
    if not is_instance_valid(selected):
        on_group_deselected()
        return
    selected_entity_wrapper = selected.get_metadata(0) as EntityWrapper
    _update_entity_editor()

func on_group_deselected():
    selected_entity_wrapper = null
    _update_entity_editor()

func _update_entity_editor():
    var _visible := is_instance_valid(selected_entity_wrapper)
    (%EntityWrapperPanel as Control).visible = _visible
    if not _visible:
        return
    if not is_instance_valid(selected_entity_wrapper.entity):
        selected_entity_wrapper.entity = entities[selected_entity_wrapper.entity_id]
    (%EntityName as LineEdit).text = selected_entity_wrapper.entity.get_editor_name()

func _set_entity():
    var selected := (%EntityTree as Tree).get_selected()
    if not is_instance_valid(selected):
        printerr("No entity selected")
        return
    selected_entity_wrapper.entity = selected.get_metadata(0)
    _update_entity_editor()

func _update_slide_tree():
    var tree := %SlideTree as Tree
    tree.clear()
    var content_root := (selected_slide.get_metadata(0) as ClassSlide).content_root
    if not is_instance_valid(content_root):
        _show_no_content()
        return
    _show_content()
    var root := tree.create_item()
    root.set_text(0, content_root.get_editor_name())
    root.set_metadata(0, content_root)
    _add_groups(root, content_root.groups)
    _add_entities(root, content_root.entities)

func _show_no_content():
    (%EmptyTreeSwitcher as SwitcherContainer).show_second = false

func _show_content():
    (%EmptyTreeSwitcher as SwitcherContainer).show_second = true

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

func _configure_groups_dropdown():
    var dropdown := %GroupDropdown as OptionButton
    for type in CustomClassDB.groups:
        if type == "ClassGroup":
            continue
        dropdown.add_item(type)

func _add_new_item_to_group():
    var dropdown := %GroupDropdown as OptionButton
    var item_type := dropdown.selected
    if item_type <= 0:
        printerr("No item type selected")
        return
    var parent := (%SlideTree as Tree).get_selected()
    if not is_instance_valid(parent):
        if is_instance_valid((%SlideTree as Tree).get_root()):
            printerr("No group selected")
        elif item_type == 1:
            printerr("Cannot add entity as root")
        else:
            _add_root_group(dropdown.get_item_text(item_type))            
        return
    if item_type == 1:
        _add_new_entity(parent)
    else:
        _add_new_group(parent, dropdown.get_item_text(item_type))

func _add_root_group(group_type: String):
    var group: ClassGroup = CustomClassDB.instantiate(group_type)
    var slide := selected_slide.get_metadata(0) as ClassSlide
    slide.content_root = group
    _update_slide_tree.call_deferred()

func _add_new_group(parent: TreeItem, group_type: String):
    var group: ClassGroup = CustomClassDB.instantiate(group_type)
    var group_item := parent.create_child()
    group_item.set_text(0, group.get_editor_name())
    group_item.set_metadata(0, group)
    parent.get_metadata(0).groups.push_back(group)

func _add_new_entity(parent: TreeItem):
    var entity: EntityWrapper = EntityWrapper.new()
    var entity_item := parent.create_child()
    entity_item.set_text(0, "EntityWrapper")
    entity_item.set_metadata(0, entity)
    parent.get_metadata(0).entities.push_back(entity)

func _remove_item_from_group():
    var selected := (%SlideTree as Tree).get_selected()
    if not is_instance_valid(selected):
        printerr("No group selected")
        return
    var parent := selected.get_parent()
    if not is_instance_valid(parent):
        (selected_slide.get_metadata(0) as ClassSlide).content_root = null
        _update_slide_tree.call_deferred()
        return
    if selected.get_metadata(0) is EntityWrapper:
        parent.get_metadata(0).entities.erase(selected.get_metadata(0))
    else:
        parent.get_metadata(0).groups.erase(selected.get_metadata(0))
    _update_slide_tree.call_deferred()

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