
extends Node

@onready var curv      = $"../CurvatureController"
@onready var rst       = $"../ResetController"
@onready var xr_origin = $"../XRBody/XROrigin3D"

const BOUNDARY_DISTANCE: float = 2.9

func _process(_delta: float) -> void:
	var dist = xr_origin.global_transform.origin.length()
	if dist > BOUNDARY_DISTANCE:
		rst.set_physics_process(true)
		curv.set_physics_process(false)
	else:
		rst.set_physics_process(false)
		curv.set_physics_process(true)
