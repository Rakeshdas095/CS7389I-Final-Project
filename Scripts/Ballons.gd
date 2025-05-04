extends Node3D

@export var float_height := 0.3
@export var float_speed  := 1.5

var base_y : float
var phase  : float

func _ready() -> void:
	base_y = global_transform.origin.y
	phase  = randi() * TAU

func _process(delta: float) -> void:
	phase += float_speed * delta
	var t = global_transform
	t.origin.y = base_y + sin(phase) * float_height
	global_transform = t

func distract() -> void:
	# pop animation: quick scale up then back
	var tw = create_tween()
	tw.tween_property(self, "scale", Vector3.ONE * 1.5, 0.15).set_trans(Tween.TRANS_SINE)
	tw.tween_property(self, "scale", Vector3.ONE,        0.15).set_trans(Tween.TRANS_SINE).set_delay(0.15)
