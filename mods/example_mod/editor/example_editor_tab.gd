extends Control

var editor_signals: EditorEventBus

@onready var add_button: Button = %AddEntityButton
@onready var counter: Label = %Counter

func _ready():
    editor_signals = Engine.get_singleton(&"EditorSignals") as EditorEventBus
    editor_signals.class_entities_changed.connect(_update_counter)
    add_button.pressed.connect(_add_example_entity)

func _add_example_entity():
    var new_entities: Array[Entity] = [ExampleEntity.new()]
    editor_signals.class_entities_add_requested.emit(new_entities)

func _update_counter(entities: Array[Entity]):
    var c = 0
    for e in entities:
        if e.get_class_name() == "ExampleEntity":
            c += 1
    counter.text = "This class has %d example entities" % c
