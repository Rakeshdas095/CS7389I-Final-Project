# ActionZone.gd
extends Area3D
func _ready() -> void:
    connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node) -> void:
    # now body will be the XRBody (CharacterBody3D)
    if body.name == "XRBody":
        # tell your RedirectionManager to rotate
        get_node("../RedirectionManager")._on_interaction()
