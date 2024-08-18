extends CanvasLayer

@export var game_timer: GameTimer
@export var intro_screen: CanvasLayer
@export var build_screen: Node2D
@export var main_menu: Control
@export var tutorial_menu: Control
@export var end_menu: Control
@export var height_tracker_label: Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.gamemode_changed.connect(gamemode_check)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func gamemode_check(new_gamemode: Globals.GAMEMODE) -> void:
	match new_gamemode:
		Globals.GAMEMODE.INTRO:
			intro_screen.show()
			intro_screen.play_intro()
			pass
		Globals.GAMEMODE.START:
			intro_screen.hide()
			main_menu.show()
			main_menu.open()
			pass
		Globals.GAMEMODE.BUILDER:
			intro_screen.hide()
			main_menu.hide()
			tutorial_menu.hide()
			build_screen.show()
			game_timer.show()
			game_timer.start_timer()
			pass
		Globals.GAMEMODE.PLAYER:
			intro_screen.hide()
			main_menu.hide()
			tutorial_menu.hide()
			height_tracker_label.show()
			build_screen.hide()
			pass
		Globals.GAMEMODE.FINISHED:
			intro_screen.hide()
			height_tracker_label.hide()
			game_timer.hide()
			end_menu.populate()
			end_menu.show()
			pass
		_:
			pass
	pass
