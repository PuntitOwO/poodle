extends Control

const DEFAULT_EXPORT_PATH = "user://tmp/index.json"

@export var class_index: ClassIndex
var editor_signals: EditorEventBus

func _enter_tree():
	# Register singleton
	Engine.register_singleton(&"EditorSignals", EditorEventBus.new())
	editor_signals = Engine.get_singleton(&"EditorSignals") as EditorEventBus

func _ready():
	# File Tab
	%NewFileButton.pressed.connect(_new_class)
	%LoadFileButton.pressed.connect(_open_class)
	get_tree().root.files_dropped.connect(_on_files_selected)
	%ExportButton.pressed.connect(export_class)
	# Handle update requests
	editor_signals.class_index_change_requested.connect(_change_index)
	editor_signals.class_metadata_change_requested.connect(_change_metadata)
	editor_signals.class_script_change_requested.connect(_change_script)
	editor_signals.class_entities_add_requested.connect(_append_entities)
	editor_signals.class_sections_change_requested.connect(_change_sections)
	# Load mod tabs
	_load_mod_tabs()
	# Update UI
	_update_tabs()

#region Update handlers

func _change_index(index: ClassIndex):
	class_index = index
	editor_signals.class_index_changed.emit(index)
	_update_tabs()

func _change_metadata(metadata: ClassMetadata):
	class_index.metadata = metadata
	editor_signals.class_metadata_changed.emit(metadata)

func _change_script(new_script: Array[ScriptEntry]):
	class_index.class_script = new_script
	editor_signals.class_script_changed.emit(new_script)

func _append_entities(entities: Array[Entity]):
	class_index.entities.append_array(entities)
	editor_signals.class_entities_changed.emit(class_index.entities)

func _change_sections(sections: Array[ClassSection]):
	class_index.sections = sections
	editor_signals.class_sections_changed.emit(sections)    

#endregion

#region Tabs

func _load_mod_tabs():
	for mod in ModLoader.mods_loaded:
		for scene in mod.editor_scenes:
			var instance = scene.instantiate()
			if not is_instance_valid(instance):
				continue
			%EntityEditors.add_child(instance)

func _update_tabs():
	var valid_file = is_instance_valid(class_index)
	var tabs := %TabContainer as TabContainer
	for i in tabs.get_tab_count() - 1:
		tabs.set_tab_disabled(i + 1, not valid_file)

#endregion

#region Create/Load File

func _new_class():
	_change_index(ClassIndex.new())

func _open_class():
	if DisplayServer.has_feature(DisplayServer.FEATURE_NATIVE_DIALOG):
		_native_dialog()
		print("Native dialog support detected. Using native file picker.")
		return
	print("No custom dialog support detected. Using built-in file picker.")
	_built_in_dialog()

func _native_dialog():
	DisplayServer.file_dialog_show("Open File", "", "", false, DisplayServer.FILE_DIALOG_MODE_OPEN_FILE, ["*.json"], _on_native_dialog_file_selected)

func _built_in_dialog():
	var dialog := FileDialog.new()
	add_child(dialog)
	dialog.use_native_dialog = true
	dialog.access = FileDialog.ACCESS_FILESYSTEM
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.add_filter("*.json", "Poodle Index Files")
	dialog.files_selected.connect(_on_files_selected)
	dialog.file_selected.connect(_on_file_selected)
	dialog.popup_centered()

func _on_native_dialog_file_selected(status: bool, selected_paths: PackedStringArray, _selected_filter_index: int) -> void:
	if status:
		_on_files_selected(selected_paths)

func _on_files_selected(files: PackedStringArray) -> void:
	for file in files:
		if file.ends_with(".json"):
			_on_file_selected(file)
			return

func _on_file_selected(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	var content := file.get_as_text()
	var index = JSON.parse_string(content)
	if index == null or typeof(index) != TYPE_DICTIONARY:
		return
	_change_index(ClassIndex.deserialize(index))

#endregion

func export_class():
	_compute_wrapper_index()
	_export_class()

func _compute_wrapper_index():
	for section in class_index.sections:
		for slide in section.slides:
			_compute_wrapper_index_in_group(slide.content_root)

func _compute_wrapper_index_in_group(group: ClassGroup):
	for inner_group in group.groups:
		_compute_wrapper_index_in_group(inner_group)
	for wrapper in group.entities:
		if not is_instance_valid(wrapper.entity):
			continue
		var index := class_index.entities.find(wrapper.entity)
		if index == -1:
			printerr("Entity not found in class index: " + wrapper.entity.get_name())
			continue
		wrapper.entity_id = index

func _export_class():
	var path: String = %ExportPath.text
	if path.is_empty():
		path = DEFAULT_EXPORT_PATH
	var relative_dir := path.replace("user://", "").replace("index.json", "")
	var dir := DirAccess.open("user://")
	if not dir.dir_exists(relative_dir):
		dir.make_dir_recursive(relative_dir)
	var final_path := "user://" + relative_dir + "index.json"
	var file := FileAccess.open(final_path, FileAccess.WRITE)
	file.store_string(JSON.stringify(class_index.serialize(), "\t"))
	file.close()
	OS.shell_open(OS.get_user_data_dir() + "/" + relative_dir + "/")
