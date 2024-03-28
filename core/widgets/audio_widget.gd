class_name AudioWidget
extends Widget

@export var entity: AudioEntity
var audio: AudioStreamPlayer

func init(_properties: Dictionary) -> void:
	var packet_sequence := AudioStreamOggVorbis.load_from_file(entity.audio_path)
	audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = packet_sequence

func play(_duration: float) -> void:
	audio.play()

func reset():
	pass

func get_duration() -> float:
	return audio.stream.get_length()
