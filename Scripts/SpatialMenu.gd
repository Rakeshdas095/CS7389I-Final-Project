extends Node3D


@export var vp_path   : NodePath
@export var mesh_path : NodePath

# These get filled in at runtime:
var viewport : SubViewport
var mesh     : MeshInstance3D
var size     : Vector2

func _ready():
    # Grab the nodes by path:
    viewport = get_node(vp_path) as SubViewport
    mesh     = get_node(mesh_path) as MeshInstance3D
    size     = viewport.size

func world_to_gui(hit_pos: Vector3) -> Vector2:

    var local = mesh.to_local(hit_pos)
    var u = (local.x / mesh.scale.x) * 0.5 + 0.5
    var v = (-local.y / mesh.scale.y) * 0.5 + 0.5
    return Vector2(u * size.x, v * size.y)

func inject_click(hit_pos: Vector3) -> void:
    var gui_pos = world_to_gui(hit_pos)
    var down = InputEventMouseButton.new()
    # Use the global BUTTON constant, not MouseButton.LEFT:
    down.button_index = MOUSE_BUTTON_LEFT
    down.pressed      = true
    down.position     = gui_pos
    viewport.input(down)
    # Release:
    down.pressed = false
    viewport.input(down)