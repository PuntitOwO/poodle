@tool
extends EditorPlugin

var exportPlugin : AndroidFilePickerPlugin

func _enter_tree():
	# Initialization of the plugin goes here.
	exportPlugin = AndroidFilePickerPlugin.new()
	add_export_plugin(exportPlugin)

func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_export_plugin(exportPlugin)
	exportPlugin = null

class AndroidFilePickerPlugin extends EditorExportPlugin:
	var pluginName = "GodotFilePicker"

	func _supports_platform(platform):
		return platform is EditorExportPlatformAndroid
	
	func _get_android_libraries(platform, debug):
		if debug:
			return PackedStringArray(["godot_file_picker/app-debug.aar"])
		else:
			return PackedStringArray(["godot_file_picker/app-release.aar"])
	
	func _get_android_dependencies(platform, debug):
		return PackedStringArray([])
	
	func _get_name():
		return pluginName