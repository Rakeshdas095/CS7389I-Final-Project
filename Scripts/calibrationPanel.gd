extends Control

@onready var sliders    : Array[Slider]    = [
	$MarginContainer/VBoxContainer/HBoxContainer/RotationSlider,
	$MarginContainer/VBoxContainer/HBoxContainer2/TranslationSlider,
	$MarginContainer/VBoxContainer/HBoxContainer3/CurvatureSlider
]
@onready var labels     : Array[Label]     = [
	$MarginContainer/VBoxContainer/HBoxContainer/RotationLabel,
	$MarginContainer/VBoxContainer/HBoxContainer2/TranslationLabel,
	$MarginContainer/VBoxContainer/HBoxContainer3/CurvatureLabel
]
@onready var confirm_btn := $MarginContainer/VBoxContainer/ConfirmCalibration

var selected_index := 0

func _ready() -> void:
	# initialize the sliders from Globals
	sliders[0].value = Globals.settings.rotation_gain
	sliders[1].value = Globals.settings.translation_gain
	sliders[2].value = Globals.settings.curvature_gain
	_update_labels()

func _process(_delta: float) -> void:
	# move between sliders
	if Input.is_action_just_pressed("calib_next_slider"):
		selected_index = (selected_index + 1) % sliders.size()
	elif Input.is_action_just_pressed("calib_prev_slider"):
		selected_index = (selected_index - 1 + sliders.size()) % sliders.size()

	# adjust current slider value
	if Input.is_action_just_pressed("calib_inc_value"):
		sliders[selected_index].value += sliders[selected_index].step
	elif Input.is_action_just_pressed("calib_dec_value"):
		sliders[selected_index].value -= sliders[selected_index].step

	# confirm and apply
	if Input.is_action_just_pressed("calib_confirm"):
		Globals.settings.rotation_gain    = sliders[0].value
		Globals.settings.translation_gain = sliders[1].value
		Globals.settings.curvature_gain   = sliders[2].value
		hide()  # hide the panel
		# now we can flip on our redirection nodes:
		var root = get_tree().current_scene
		root.get_node("RedirectionManager").set_process_input(true)
		root.get_node("CurvatureController").set_physics_process(true)
		root.get_node("ResetController").set_physics_process(true)
		root.get_node("MetaStrategyManager").set_process(true)

	_update_labels()


func _update_labels() -> void:
	for i in range(sliders.size()):
		# update text
		var v := "%0.2f" % sliders[i].value
		labels[i].text = [
			"Rotation Gain: %s"    % v,
			"Translation Gain: %s" % v,
			"Curvature Gain: %s"   % v
		][i]
		# highlight the selected slider’s grabber
		var radius := 10 if i == selected_index else 5
		sliders[i].add_theme_constant_override("grabber_radius", radius)
