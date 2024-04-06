extends Node

@onready var class_scene: ConceptClassScene = $ParseAndPlay
@onready var window: ConceptClassWindow = $ClassWindow

func _ready():
    _setup_scene()

func _setup_scene():
    print("Setting up scene")
    window.set_class_node(class_scene)
    window.set_section_tree(class_scene.section_manager.tree)
    class_scene.compute_duration()
    window.set_total_time(ceili(class_scene.total_duration))
    class_scene.play()