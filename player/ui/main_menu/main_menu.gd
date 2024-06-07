extends Control

@onready var open_button: Button = %Open
@onready var open_debug_button: Button = %OpenDebug
@onready var open_tutorial_button: Button = %OpenTutorial
@onready var open_settings_button: Button = %OpenSettings

@onready var drop_label: Label = %DropLabel
@onready var settings_window: Window = $SettingsWindow

func _ready():
	open_button.pressed.connect(_select_file)
	open_debug_button.pressed.connect(_built_in_dialog.bind(false))
	open_tutorial_button.pressed.connect(_on_file_selected.bind("res://concept/example_class/clase_ejemplo.poodle"))
	open_settings_button.pressed.connect(settings_window.show)
	settings_window.close_requested.connect(settings_window.hide)
	get_tree().root.files_dropped.connect(_on_files_dropped)
	drop_label.visible = not OS.has_feature("mobile")
	open_debug_button.visible = OS.has_feature("debug")

func _select_file():
	if OS.has_feature("android"):
		print("Android detected. Using Android file picker.")
		_android_dialog()
		return
	if DisplayServer.has_feature(DisplayServer.FEATURE_NATIVE_DIALOG):
		_native_dialog()
		print("Native dialog support detected. Using native file picker.")
		return
	print("No custom dialog support detected. Using built-in file picker.")
	_built_in_dialog()

func _android_dialog():
	if Engine.has_singleton("GodotFilePicker"):
		var picker = Engine.get_singleton("GodotFilePicker")
		if not picker.file_picked.is_connected(_on_android_file_selected):
			picker.file_picked.connect(_on_android_file_selected)
		picker.openFilePicker("*/*")
	else:
		printerr("GodotFilePicker singleton not found")
		return

func _on_android_file_selected(path: String, _mime_type: String) -> void:
	_on_file_selected(path)

func _native_dialog():
	DisplayServer.file_dialog_show("Open File", "", "", false, DisplayServer.FILE_DIALOG_MODE_OPEN_FILE, ["*.poodle", "*.zip"], _on_native_dialog_file_selected)

func _built_in_dialog(try_native: bool = true):
	var dialog := FileDialog.new()
	add_child(dialog)
	dialog.use_native_dialog = try_native
	dialog.access = FileDialog.ACCESS_USERDATA
	dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialog.add_filter("*.poodle, *.zip", "Poodle Class Files")
	dialog.files_selected.connect(_on_files_dropped)
	dialog.file_selected.connect(_on_file_selected)
	dialog.popup_centered(Vector2i(540, 360))

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
	if not path.ends_with(".poodle") and not path.ends_with(".zip"):
		printerr("Invalid file type: ", path)
		return
	Persistence.class_path = path
	print("Selected file: ", Persistence.class_path)
	get_tree().change_scene_to_file("res://player/ui/player_screen/main/main.tscn")
