extends Control

@onready var open_button: Button = %Open

func _ready():
    open_button.pressed.connect(_select_file)
    get_tree().root.files_dropped.connect(_on_files_dropped)

func _select_file():
    if OS.has_feature("android"):
        print("Android detected. Using Android file picker.")
        _android_dialog()
        return
    if !DisplayServer.has_feature(DisplayServer.FEATURE_NATIVE_DIALOG):
        _built_in_dialog()
        return
    _native_dialog()

func _android_dialog():
    if Engine.has_singleton("GodotFilePicker"):
        var picker = Engine.get_singleton("GodotFilePicker")
        picker.file_picked.connect(_on_android_file_selected)
        picker.openFilePicker("*/*")
    else:
        printerr("GodotFilePicker singleton not found")
        return

func _on_android_file_selected(path: String, _mime_type: String) -> void:
    _on_file_selected(path)

func _native_dialog():
    DisplayServer.file_dialog_show("Open File", "", "", false, DisplayServer.FILE_DIALOG_MODE_OPEN_FILE, ["*.poodle", "*.zip"], _on_native_dialog_file_selected)

func _built_in_dialog():
    var dialog := FileDialog.new()
    add_child(dialog)
    dialog.use_native_dialog = true
    dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
    dialog.add_filter("*.poodle, *.zip", "Poodle Class Files")
    dialog.file_selected.connect(_on_file_selected)
    dialog.popup_centered()

func _on_native_dialog_file_selected(status: bool, selected_paths: PackedStringArray, _selected_filter_index: int) -> void:
    if status == false:
        return
    var path := selected_paths[0]
    _on_file_selected(path)

func _on_files_dropped(files: PackedStringArray) -> void:
    for file in files:
        if file.ends_with(".poodle") or file.ends_with(".zip"):
            _on_file_selected(file)
            return

func _on_file_selected(path: String) -> void:
    Persistence.class_path = path
    print("Selected file: ", Persistence.class_path)
    get_tree().change_scene_to_file("res://concept/parse_and_play/parse_and_play.tscn")