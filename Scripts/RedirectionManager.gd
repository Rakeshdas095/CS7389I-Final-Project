extends Node3D

@onready var xr_origin : Node3D          = get_node("../XRBody/XROrigin3D")
@onready var left_ctrl  : XRController3D = xr_origin.get_node("LeftController")
@onready var right_ctrl : XRController3D = xr_origin.get_node("RightController")

var rotation_gain : float = 1.0

func _ready() -> void:
    rotation_gain = Globals.settings.rotation_gain
    left_ctrl.connect("button_pressed",  Callable(self, "_on_button_pressed"))
    right_ctrl.connect("button_pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed(action_name: String) -> void:
    if action_name == "trigger":
        var angle = deg_to_rad(10.0 * rotation_gain)
        xr_origin.rotate_y(angle)