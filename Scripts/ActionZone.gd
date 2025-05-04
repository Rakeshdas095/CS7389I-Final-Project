extends Area3D
signal zone_triggered(body: Node)

func _ready() -> void:
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
	emit_signal("zone_triggered", body)
