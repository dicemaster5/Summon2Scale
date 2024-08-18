extends Node

enum GAMEMODE {
	INTRO,
	START,
	BUILDER,
	PLAYER,
	FINISHED,
}

var current_gamemode: GAMEMODE

signal block_clicked
signal gamemode_changed

var mouse_in_tower_area: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	change_gamemode(GAMEMODE.INTRO)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_key_pressed(KEY_BACKSPACE) || Input.is_key_pressed(KEY_ESCAPE):
		get_tree().reload_current_scene()
		change_gamemode(GAMEMODE.START)
		print("Game Restarted!")

	# restart game in build mode
	if Input.is_key_pressed(KEY_R):
		get_tree().reload_current_scene()
		await get_tree().create_timer(0.01).timeout
		call_deferred("change_gamemode", GAMEMODE.BUILDER)
		print("build mode Restarted!")

func change_gamemode(new_gamemode: GAMEMODE) -> void:
	current_gamemode = new_gamemode
	gamemode_changed.emit(new_gamemode)

func _input(event: InputEvent) -> void:
	if OS.is_debug_build() and Input.is_key_pressed(KEY_P):
		print("p pressed. finish game.")
		change_gamemode(GAMEMODE.FINISHED)
