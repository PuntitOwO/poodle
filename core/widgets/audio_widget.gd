class_name AudioWidget
extends Widget

@export var entity: AudioEntity
var audio: AudioStreamPlayer

func init(_properties: Dictionary) -> void:
	if !zip_file.file_exists(entity.audio_path):
		push_error("Audio file not found: " + entity.audio_path)
		return
	var data := zip_file.read_file(entity.audio_path)
	var packet_sequence := AudioStreamOggVorbis.load_from_buffer(data)
	audio = AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = packet_sequence

func play(_duration: float) -> void:
	audio.play()
	if audio.finished.is_connected(_emit_animation_finished):
		return
	audio.finished.connect(_emit_animation_finished, CONNECT_ONE_SHOT)

func reset():
	if audio.finished.is_connected(_emit_animation_finished):
		audio.finished.disconnect(_emit_animation_finished)
	audio.stop()

## Returns the duration of the audio in seconds.
func compute_duration() -> float:
	return audio.stream.get_length()