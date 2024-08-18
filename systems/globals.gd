extends Node

enum GAMEMODE {
	INTRO,
	START,
	BUILDER,
	PLAYER,
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
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_BACKSPACE) || Input.is_key_pressed(KEY_SPACE):
		change_gamemode(GAMEMODE.START)
		get_tree().reload_current_scene()
		print("Game Restarted!")

	pass

func change_gamemode(new_gamemode: GAMEMODE) -> void:
	current_gamemode = new_gamemode
	gamemode_changed.emit(new_gamemode)