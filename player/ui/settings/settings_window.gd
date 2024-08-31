extends Window

@onready var manage_mods_button = %ManageModsButton
@onready var mod_alert_accepted = ModLoader.mod_alert_accepted

@onready var security_alert_window = $SecurityAlertWindow
@onready var alert: PanelContainer = %Alert

func _ready():
	alert.position.x = -alert.size.x
	manage_mods_button.pressed.connect(_on_mods_button_pressed)
	_mod_alert_accepted.connect(_load_mods)
	_ready_security_alert()

func _show_alert():
	var _tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	_tween.tween_property(alert, ^"position:x", 0, 0.6).set_ease(Tween.EASE_OUT)
	_tween.tween_property(alert, ^"position:x", -alert.size.x, 0.2).set_delay(4.0).set_ease(Tween.EASE_IN)

func _on_mods_button_pressed():
	if mod_alert_accepted:
		# open some mod managing screen
		_load_mods()
	else:
		_show_security_alert()

func _load_mods():
	if not mod_alert_accepted: return
	if not ModLoader.mods_loaded.is_empty(): return
	ModLoader.load_mods()
	_show_alert()

#region Security Alert

signal _mod_alert_accepted

@onready var cancel_button: Button = %Cancel
@onready var accept_button: Button = %Accept
@onready var check_box: CheckBox = %CheckBox

var time_passed := false
var check_box_activated := false
var tween: Tween

func _ready_security_alert():
	security_alert_window.close_requested.connect(_hide_security_alert)
	cancel_button.pressed.connect(_hide_security_alert)
	accept_button.pressed.connect(_accept_security_alert)
	check_box.toggled.connect(_set_check_box)

func _show_security_alert():
	security_alert_window.show()
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_callback(_set_time_passed.bind(false))
	tween.tween_method(_update_accept_button_text, 10, 1, 10.0)
	tween.tween_callback(func (): accept_button.text = "Accept").set_delay(1.0)
	tween.tween_callback(_set_time_passed.bind(true))

func _set_check_box(on: bool):
	check_box_activated = on
	_update_accept_button()

func _set_time_passed(passed: bool):
	time_passed = passed
	_update_accept_button()

func _update_accept_button():
	var enabled := time_passed and check_box_activated
	accept_button.disabled = not enabled

func _update_accept_button_text(time: int):
	accept_button.text = "Accept (%d)" % time

func _hide_security_alert():
	security_alert_window.hide()
	if tween: tween.kill()
	accept_button.text = "Accept"
	accept_button.disabled = true

func _accept_security_alert():
	ModLoader.accept_security_alert()
	mod_alert_accepted = true
	_hide_security_alert()
	_mod_alert_accepted.emit()

#endregion
