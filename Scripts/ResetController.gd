extends Node3D

# ← match your TorusMesh inner radius
const RESET_THRESHOLD := 2.9
const RESET_SPEED     := 1.0

@onready var xr_origin : Node3D        = get_node("../XRBody/XROrigin3D")
@onready var ring_node : MeshInstance3D = get_node("../BoundaryRing")  
var ring_mat       : StandardMaterial3D
var normal_color   : Color
var warning_color  := Color(1, 0, 0)    # bright red

func _ready() -> void:
	# Duplicate the material so we don't edit a shared resource
	ring_mat = ring_node.material_override.duplicate() as StandardMaterial3D
	ring_node.material_override = ring_mat
	# It is soft-teal emission
	normal_color = ring_mat.emission

func _physics_process(delta: float) -> void:
	# 1) measure distance from center
	var dist = xr_origin.global_transform.origin.length()

	if dist > RESET_THRESHOLD:
		_flash_warning()
		# 2) push them gently back toward the center
		var dir = -xr_origin.global_transform.origin.normalized()
		xr_origin.translate(dir * RESET_SPEED * delta)
	else:
		# restore normal glow
		ring_mat.emission = normal_color

func _flash_warning() -> void:
	# only re-flash if we’re not already mid-tween
	if ring_mat.emission == warning_color:
		return

	ring_mat.emission = warning_color
	# tween back to the normal teal over 0.5s
	var tw = create_tween()
	tw.tween_property(ring_mat, "emission", normal_color, 0.5)
