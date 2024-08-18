extends Area2D


@export_flags("SLOW:1","FAST:2","LITTLEJUMP:4","BIGJUMP:8") var status_effects: int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if Globals.current_gamemode == Globals.GAMEMODE.PLAYER and body is Player:
		body.status_effects = status_effects



func _on_body_exited(body: Node2D) -> void:
	if Globals.current_gamemode == Globals.GAMEMODE.PLAYER and body is Player:
		body.status_effects -= status_effects
