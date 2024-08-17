extends Node

enum GAMEMODE {
	BUILDER,
	PLAYER,
	START,
	FINISHED,
}

var current_gamemode: GAMEMODE = GAMEMODE.START

signal block_clicked
signal gamemode_changed

var mouse_in_tower_area: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_gamemode(new_gamemode: GAMEMODE) -> void:
	current_gamemode = new_gamemode
	gamemode_changed.emit(new_gamemode)