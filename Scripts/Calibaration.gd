
extends Control

func _ready() -> void:
	# Initialize sliders from Globals
	$MarginContainer/VBoxContainer/HBoxContainer/RotationSlider.value    = Globals.settings.rotation_gain
	$MarginContainer/VBoxContainer/HBoxContainer2/TranslationSlider.value = Globals.settings.translation_gain
	$MarginContainer/VBoxContainer/HBoxContainer3/CurvatureSlider.value   = Globals.settings.curvature_gain

	# Wire up callbacks
	$MarginContainer/VBoxContainer/HBoxContainer/RotationSlider.connect("value_changed",    Callable(self, "_on_rotation_changed"))
	$MarginContainer/VBoxContainer/HBoxContainer2/TranslationSlider.connect("value_changed", Callable(self, "_on_translation_changed"))
	$MarginContainer/VBoxContainer/HBoxContainer3/CurvatureSlider.connect("value_changed",   Callable(self, "_on_curvature_changed"))
	$MarginContainer/VBoxContainer/ConfirmCalibration.connect("pressed",                      Callable(self, "_on_confirm"))


func _on_rotation_changed(val: float) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer/RotationLabel.text = "Rotation Gain: " + str(val)

func _on_translation_changed(val: float) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer2/TranslationLabel.text = "Translation Gain: " + str(val)

func _on_curvature_changed(val: float) -> void:
	$MarginContainer/VBoxContainer/HBoxContainer3/CurvatureLabel.text = "Curvature Gain: " + str(val)


func _on_confirm() -> void:
	# 1) Save gains
	Globals.settings.rotation_gain    = $MarginContainer/VBoxContainer/HBoxContainer/RotationSlider.value
	Globals.settings.translation_gain = $MarginContainer/VBoxContainer/HBoxContainer2/TranslationSlider.value
	Globals.settings.curvature_gain   = $MarginContainer/VBoxContainer/HBoxContainer3/CurvatureSlider.value

	# Hide the calibration panel
	hide()

	# Enable VR logic nodes under the MainVR root
	var root = get_tree().current_scene  # this is the MainVR node
	root.get_node("RedirectionManager").set_process_input(true)
	root.get_node("CurvatureController").set_physics_process(true)
	root.get_node("ResetController").set_physics_process(true)
	root.get_node("MetaStrategyManager").set_process(true)
