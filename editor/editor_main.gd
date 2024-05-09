extends Control

const DEFAULT_EXPORT_PATH = "user://tmp/index.json"

@export var class_index: ClassIndex

func _ready():
    # File Tab
    %NewFileButton.pressed.connect(_new_class)
    %LoadFileButton.pressed.connect(_open_class)
    get_tree().root.files_dropped.connect(_on_files_selected)
    %ExportButton.pressed.connect(_export_class)
    # Metadata Tab
    %Metadata.metadata_changed.connect(func (m): class_index.metadata = m)
    # Script Tab
    %Script.script_entries_changed.connect(func (s): class_index.class_script = s)
    # Update UI
    _update_tabs()

func _update_tabs():
    var valid_file = is_instance_valid(class_index)
    var tabs := %TabContainer as TabContainer
    for i in tabs.get_tab_count() - 1:
        tabs.set_tab_disabled(i + 1, not valid_file)

#region Create/Load File

func _new_class():
    class_index = ClassIndex.new()
    _update_tabs()

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
    class_index = ClassIndex.deserialize(index)
    %TabContainer.propagate_call("on_class_index_changed", [class_index])
    _update_tabs()

#endregion

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