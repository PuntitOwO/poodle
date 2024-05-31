extends Control

@export var script_entries: Array[ScriptEntry]
@export var edit: ClassScriptCodeEdit
var editor_signals: EditorEventBus

var section_counter := 1
var slide_counter := 1


func _ready():
    %SaveButton.pressed.connect(parse)
    %SectionsButton.pressed.connect(compute_sections_ask)
    %EntitiesButton.pressed.connect(compute_entities)
    editor_signals = Engine.get_singleton(&"EditorSignals") as EditorEventBus
    editor_signals.class_index_changed.connect(_on_class_index_changed)
    editor_signals.class_script_changed.connect(_on_class_script_changed)

func _on_class_index_changed(index: ClassIndex):
    _on_class_script_changed(index.class_script)

func _on_class_script_changed(entries: Array[ScriptEntry]):
    if script_entries == entries:
        return
    script_entries = entries
    _load.call_deferred()

func _load():
    var text := ""
    for entry in script_entries:
        var line := entry.content
        if entry is CommentEntry:
            if line.begins_with("Slide"):
                line = "\n==" + remove_until(line, ": ")
            elif line.begins_with("Sec"):
                line = "\n=" + remove_until(line, ": ")
            else:
                line = "#" + line
        elif entry is AltTextEntry:
            line = "##" + line
        text += line + "\n"
    edit.text = text

func remove_until(line: String, until: String) -> String:
    var index = line.find(until)
    if index == -1:
        return line
    return line.substr(index + until.length())

func parse():
    script_entries = parse_text()
    editor_signals.class_script_change_requested.emit(script_entries)

func compute_sections_ask():
    var dialog: ConfirmationDialog = ConfirmationDialog.new()
    add_child(dialog)
    dialog.title = "Confirm action: Compute Sections"
    dialog.dialog_text = "This action will compute the sections from the current script.\nIt will replace your current section data.\nAre you sure you want to proceed?"
    dialog.confirmed.connect(compute_sections)
    dialog.initial_position = Window.WINDOW_INITIAL_POSITION_CENTER_MAIN_WINDOW_SCREEN
    dialog.popup()

func compute_sections():
    var sections: Array[ClassSection] = []
    for entry in parse_text():
        if not entry is CommentEntry: continue
        var line := entry.content
        if line.begins_with("Slide"):
            line = remove_until(line, ": ")
            if sections.is_empty():
                printerr("No section for slide")
                continue
            var section := sections[-1]
            var new_slide := ClassSlide.new()
            new_slide.name = line
            section.slides.append(new_slide)
        elif line.begins_with("Sec"):
            line = remove_until(line, ": ")
            var new_section := ClassSection.new()
            new_section.name = line
            sections.append(new_section)
    editor_signals.class_sections_change_requested.emit(sections)

func compute_entities():
    var entities: Array[Entity] = []
    for entry in parse_text():
        if not entry is TextEntry: continue
        var line := entry.content
        var new_entity := TextEntity.new()
        new_entity.content = line
        entities.append(new_entity)
    editor_signals.class_entities_add_requested.emit(entities)

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
    