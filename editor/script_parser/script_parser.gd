extends Control

@export var edit: ClassScriptCodeEdit

var section_counter := 1
var slide_counter := 1

@onready var test_button: Button = $Button

var test_parse: Array[ScriptEntry]

func _ready():
    test_button.pressed.connect(_test_parse)

func _test_parse():
    test_parse = parse_text()

func parse_text() -> Array[ScriptEntry]:
    var entries: Array[ScriptEntry] = []
    var lines := edit.text.split("\n")
    for line in lines:
        var entry := parse_line(line)
        if entry != null:
            entries.append(entry)
    return entries

func parse_line(line: String) -> ScriptEntry:
    var entry: ScriptEntry
    if line.is_empty():
        return null
    if line.begins_with("=="):
        entry = CommentEntry.new()
        entry.content = "Slide " + str(section_counter)+ ": " + line.trim_prefix("==")
        slide_counter += 1
        return entry
    if line.begins_with("="):
        entry = CommentEntry.new()
        entry.content = "Section " + str(section_counter)+ ": " + line.trim_prefix("=")
        section_counter += 1
        slide_counter = 1
        return entry
    if line.begins_with("##"):
        entry = AltTextEntry.new()
        entry.content = line.trim_prefix("##")
        return entry
    if line.begins_with("#"):
        entry = CommentEntry.new()
        entry.content = line.trim_prefix("#")
        return entry
    entry = TextEntry.new()
    entry.content = line
    return entry
    