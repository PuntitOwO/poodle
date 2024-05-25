extends Node

var mod_folder_exists = false

## Returns the mods folder, creating it if it doesn't exist.
## If the folder couldn't be created, mod_folder_exists will be false.
func get_mods_folder() -> DirAccess:
    var dir := DirAccess.open("user://")
    if not dir.dir_exists("mods"):
        dir.make_dir_recursive("mods")
    var status := dir.change_dir("mods")
    if status == OK:
        mod_folder_exists = true
    return dir

## Returns a list of all mods in the mods folder.
func get_mods_list() -> Array[ModPath]:
    var dir := get_mods_folder()
    if not mod_folder_exists:
        return []
    var mods: Array[ModPath] = []
    for folder in dir.get_directories():
        var mod_path := ModPath.from_dir(dir, folder)
        if mod_path.is_valid:
            mods.append(mod_path)
    dir.close()
    return mods

## Loads a mod from the mods folder. Returns true on success.
func load_mod(mod_path: ModPath, editor: bool = false) -> bool:
    var file := mod_path.editor_mod_file if editor else mod_path.mod_file
    var full_path := "user://mods/" + mod_path.folder + "/" + file
    return ProjectSettings.load_resource_pack(full_path, false)

## Loads all mods from the mods folder. Returns the quantity of mods loaded.
func load_all_mods(editor: bool = false) -> int:
    var mods := get_mods_list()
    var success = 0
    for mod in mods:
        if load_mod(mod, editor):
            success += 1
    CustomClassDB.force_update_classes()
    return success

func _ready():
    if OS.has_feature(&"poodle-editor"):
        load_all_mods(true)
    else:
        load_all_mods(false)

## Class representing a mod in the mods folder.
class ModPath:
    var folder: String
    var mod_file: String
    var editor_mod_file: String

    var has_mod_file: bool:
        get:
            return mod_file != ""
    
    var has_editor_mod_file: bool:
        get:
            return editor_mod_file != ""
    
    var is_valid: bool:
        get:
            return has_mod_file or has_editor_mod_file

    static func from_dir(dir: DirAccess, _folder: String) -> ModPath:
        var mod_path := ModPath.new()
        mod_path.folder = _folder
        mod_path.mod_file = ""
        mod_path.editor_mod_file = ""
        dir.change_dir(_folder)
        for file in dir.get_files():
            if file.ends_with("_mod.pck"):
                mod_path.mod_file = file
            if file.ends_with("_emod.pck"):
                mod_path.editor_mod_file = file
        dir.change_dir("..")
        return mod_path