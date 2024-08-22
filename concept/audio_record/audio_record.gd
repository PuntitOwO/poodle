extends Node

## Audio Record Proof of Concept
##
## A sample scene to test microphone audio recording.
## It has three toggle buttons: record, mute and playback.
##
## It also has a list of all recordings in this session.
## All recordings can be played by selecting (double click or enter).
## Recordings can also be saved to disk.
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
	%FileName.text_changed.connect(update_save_button)
	%Save.pressed.connect(save_recording_to_file)
	%OpenFolder.pressed.connect(open_recording_folder)

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

## Enables or disables the save button.
func update_save_button(text: String):
	%Save.disabled = text.is_empty()

## Saves the recording to a file.
func save_recording_to_file():
	var path := OS.get_user_data_dir() + "/recorded_audio/"
	var selected_recording = %ItemList.get_selected_items()
	if selected_recording.size() == 0:
		return
	var recording := recordings[selected_recording[0]]
	var file_name := (%FileName as LineEdit).text
	recording.save_to_wav(path + file_name)

## Opens the folder where all recordings are saved.
func open_recording_folder():
	var path := OS.get_user_data_dir() + "/recorded_audio/"
	OS.shell_open(path)
