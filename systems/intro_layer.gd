extends CanvasLayer

@export var do_intro: bool = true
@export var mainmenu: Control

@export var fader: Sprite2D
@export var animated_splash: AnimatedSprite2D
@export var static_splash: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_watch_gamemode(Globals.GAMEMODE.INTRO)
	Globals.gamemode_changed.connect(_watch_gamemode)

func _watch_gamemode(gm):
	print("new gamemode: %s" % gm)
	if gm == Globals.GAMEMODE.INTRO:
		show()
		static_splash.hide()
		animated_splash.hide()
		fader.show()
		play_intro()
	else:
		hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_game():
	Globals.change_gamemode(Globals.GAMEMODE.START)
	queue_free()

func play_intro():
	# initial timer
	await get_tree().create_timer(1).timeout
	# fade in animated splash
	animated_splash.show()
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(fader, "modulate", Color("#0000"), 2)
	tween.play()
	await tween.finished
	# wait
	await get_tree().create_timer(3).timeout
	# fade out
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(fader, "modulate", Color("#000f"), 2)
	tween.play()
	await tween.finished
	# fade in static splash
	animated_splash.hide()
	static_splash.show()
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	tween.tween_property(fader, "modulate", Color("#0000"), 2)
	tween.play()
	await tween.finished
	return true

func _input(event):
	if Globals.current_gamemode != Globals.GAMEMODE.INTRO:
		return
	if event is not InputEventMouseMotion:
		start_game()
