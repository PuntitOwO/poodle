class_name AudioWidget
extends Widget

@export var entity: AudioEntity
@onready var audio: AudioStreamPlayer = $Audio
var tween: Tween

func init(_properties: Dictionary) -> void:
	var packet_sequence := AudioStreamOggVorbis.load_from_file(entity.audio_path) 
	audio.stream = packet_sequence

func play(_duration: float) -> void:
	audio.play()

func reset():
	pass

func get_duration() -> float:
	return audio.stream.get_length()