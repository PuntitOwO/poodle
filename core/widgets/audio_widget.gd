class_name AudioWidget
extends Widget

@export var entity: AudioEntity
@onready var audio: AudioStreamPlayer = $Audio
var tween: Tween

func _ready():
	init()

func init() -> void:
	var packet_sequence := AudioStreamOggVorbis.load_from_file(entity.audio_path) 
	audio.stream = packet_sequence

func play(_duration: float) -> void:
	audio.play()

func unplay():
	pass