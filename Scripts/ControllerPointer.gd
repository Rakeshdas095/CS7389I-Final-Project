extends XRController3D

# Only need to know where our RayCast sits under the controller
@export var ray_path : NodePath = "RayCast3D"

var ray : RayCast3D
@onready var manager := get_tree().current_scene.get_node("RedirectionManager") as Node

func _ready() -> void:
	ray = get_node(ray_path) as RayCast3D
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.pressed:
		if ray.is_colliding():
			var collider = ray.get_collider()
			# Did we hit the ActionZone?
			if collider and collider.name == "ActionZone":
				# call your redirection manager
				manager._on_interaction(0, 0)
