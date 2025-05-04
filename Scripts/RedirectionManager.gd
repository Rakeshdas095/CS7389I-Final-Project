extends Node3D


@onready var xr_origin   : Node3D = get_tree().current_scene.get_node("XROrigin3D")
@onready var balloons_ct : Node   = get_tree().current_scene.get_node("Balloons")

# @onready var parent      := get_parent()
#_add_constant_central_force@onready var xr_origin   : Node3D = parent.get_node("XROrigin3D")
#@onready var balloons_ct : Node   = parent.get_node("Balloons")

var balloons := []
var rotation_gain := 1.0

func _ready() -> void:
	rotation_gain = Globals.settings.rotation_gain
	balloons     = balloons_ct.get_children()
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.pressed:
		_on_interaction(event.device, event.button_index)

func _on_interaction(_device: int, _button: int) -> void:
	var angle = deg_to_rad(10.0 * rotation_gain)
	xr_origin.rotate_y(angle)
	if balloons.size() > 0:
		var b = balloons[randi() % balloons.size()]
		b.distract()
		
		
