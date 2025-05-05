extends CharacterBody3D

# --- Tunable parameters ---
@export var max_speed: float                = 2.5    # meters/sec
@export var dead_zone: float                = 0.2
@export var smooth_turn_speed: float        = 45.0   # deg/sec
@export var smooth_turn_dead_zone: float    = 0.2

@export var snap_turn_angle: float          = 45.0   # degrees per snap
@export var snap_turn_threshold: float      = 0.9    # stick deflection

@export var steering_hand: String           = "right"  # "left" or "right"

# Drag‑and‑drop your controller nodes here in the Inspector,
# or let the script auto‑find them if you leave blank.
@export var left_controller: XRController3D
@export var right_controller: XRController3D

# --- Internal state ---
var input_vector: Vector2       = Vector2.ZERO
var hand_directed_steering: bool = false
var snap_turn_mode: bool         = false
var can_snap_turn: bool          = true


func _ready() -> void:
    # Auto‑assign controllers if not set in the Inspector
    if not left_controller:
        left_controller = $XROrigin3D/LeftController
    if not right_controller:
        right_controller = $XROrigin3D/RightController

    # Listen for button presses on each XRController
    #left_controller.connect("button_pressed",  Callable(self, "_on_controller_button_pressed"))
    #right_controller.connect("button_pressed", Callable(self, "_on_controller_button_pressed"))
    left_controller.connect("input_vector2_changed",  Callable(self, "process_input"))
    right_controller.connect("input_vector2_changed", Callable(self, "process_input"))


func _input(event: InputEvent) -> void:
    if event is InputEventJoypadMotion:
        match event.axis:
            0:
                input_vector.x = event.axis_value
            1:
                input_vector.y = event.axis_value


func _process(delta: float) -> void:
    # — Forward/back movement —
    if abs(input_vector.y) > dead_zone:
        var speed = max_speed * -input_vector.y
        var movement = Vector3(0, 0, speed * delta)

        if hand_directed_steering:
            var ctrl = left_controller if steering_hand == "left" else right_controller
            var yaw = ctrl.global_transform.basis.get_euler().y
            movement = movement.rotated(Vector3.UP, yaw)
        else:
            var cam_yaw = $XROrigin3D/Camera.global_transform.basis.get_euler().y
            movement = movement.rotated(Vector3.UP, cam_yaw)

        translate_object_local(movement)

    # — Turning —
    if snap_turn_mode:
        # Snap turn mode
        if can_snap_turn and abs(input_vector.x) >= snap_turn_threshold:
            _perform_snap_turn(input_vector.x)
            can_snap_turn = false
        elif abs(input_vector.x) < dead_zone:
            can_snap_turn = true
    else:
        if abs(input_vector.x) > smooth_turn_dead_zone:
            var cam_pos = $XROrigin3D/Camera.global_transform.origin
            var angle  = deg_to_rad(smooth_turn_speed) * -input_vector.x * delta
            
            translate(-cam_pos)
            rotate_y(angle)
            translate(cam_pos)


func _perform_snap_turn(direction_value: float) -> void:
    var dir     = 1 if direction_value > 0 else -1
    var cam_pos = $XROrigin3D/Camera.global_transform.origin
    var angle   = deg_to_rad(snap_turn_angle * dir)
    
    translate(-cam_pos)
    rotate_y(angle)
    translate(cam_pos)


func _on_controller_button_pressed(action_name: String) -> void:
    # Print once in the editor/Quest log to see exactly what gets fired:
    # print("Button pressed:", action_name)

    # Toggle hand‑directed steering when user presses A (Xbox) / X (Quest):
    if action_name == "ax_button":
        hand_directed_steering = !hand_directed_steering
        print("Hand‑directed steering:", hand_directed_steering)

    # Toggle snap‑turn mode when user presses B (Xbox) / Y (Quest):
    elif action_name == "by_button":
        snap_turn_mode = !snap_turn_mode
        print("Snap‑turn mode:", snap_turn_mode)