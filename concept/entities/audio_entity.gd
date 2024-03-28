extends Node

@export var resource: AudioEntity

# Called when the node enters the scene tree for the first time.
func _ready():
	_play()

func _play():
	var packet_sequence := AudioStreamOggVorbis.load_from_file(resource.audio_path)
	var audio_stream_player := AudioStreamPlayer.new()
	audio_stream_player.stream = packet_sequence
	audio_stream_player.autoplay = true
	add_child(audio_stream_player)
