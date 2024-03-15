extends Node

## Audio Record Proof of Concept
##
## A sample scene to test microphone audio recording.
## It has three toggle buttons: record, mute and playback.
## 
## It also has a list of all recordings in this session.
## All recordings can be played by selecting (double click or enter).
##
## Note: for this scene to work,
## [member ProjectSettings.audio/driver/enable_input]
## must be [code]true[/code].

## Array of all recordings of this instance.
var recordings: Array[AudioStreamWAV] = []

## [Class AudioEffectRecord] to control recording.
@onready var record: AudioEffectRecord = AudioServer.get_bus_effect(AudioServer.get_bus_index("Record"), 0)

func _ready():
	%Toggle.toggled.connect(_toggle_recording)
	%Mute.toggled.connect(_toggle_mute)
	%Playback.toggled.connect(_toggle_playback)
	%ItemList.item_activated.connect(_on_item_activated)
	$RecordReplay.finished.connect(_toggle_mute.bind(false))

# When microphone is muted, recording toggle button is disabled.
func _toggle_mute(disabled: bool):
	$RecordAudioStreamPlayer.playing = not disabled
	%Toggle.disabled = disabled

func _toggle_recording(active: bool):
	if active:
		start_recording()
	else:
		stop_recording()

func _toggle_playback(active: bool):
	AudioServer.set_bus_mute(AudioServer.get_bus_index(&"RecordPlayback"), not active)

func _on_item_activated(index: int):
	if index > recordings.size():
		return
	var recording = recordings[index]
	_toggle_mute(true)
	$RecordReplay.stream = recording
	$RecordReplay.play()

## Starts a new recording. [br]
## When a new recording starts,
## mute toggle button is disabled and
## Status label text changed to "On".
func start_recording():
	record.set_recording_active(true)
	%Mute.disabled = true
	%Status.text = "On"

## Stops the recording. [br]
## The recording is saved, mute button enabled again,
## and Status label text changed to "Off"
func stop_recording():
	save_recording()
	record.set_recording_active(false)
	%Mute.disabled = false
	%Status.text = "Off"

## Saves the current recording.
func save_recording():
	recordings.append(record.get_recording())
	%ItemList.add_item(Time.get_time_string_from_system())
