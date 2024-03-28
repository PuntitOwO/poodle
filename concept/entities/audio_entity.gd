extends Node

@export var resource: AudioEntity

var player: AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	init()

func init():
	var packet_sequence := AudioStreamOggVorbis.load_from_file(resource.audio_path)
	player = AudioStreamPlayer.new()
	player.stream = packet_sequence
	add_child(player)

func play():
	player.play()

func reset():
	pass