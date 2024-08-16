extends Area2D

@export var win_screen_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		var win_screen: Control = win_screen_scene.instantiate()
		add_sibling(win_screen)
	pass # Replace with function body.
