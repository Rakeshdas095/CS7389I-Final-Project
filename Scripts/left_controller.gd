extends XRController3D

@export var is_left_hand: bool = true

func _ready() -> void:
	# assign the correct OpenXR tracker name
	tracker = "left_hand" if is_left_hand else "right_hand"
	show_when_tracked = true  
