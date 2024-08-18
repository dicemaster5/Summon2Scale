extends Control

@export var magical_scroll: AnimatedSprite2D
@export var menu_container: HBoxContainer
@export var button_skip: Button
@export var timer: Timer
@export var time_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.timeout.connect(self._start_game)
	button_skip.pressed.connect(self._start_game)

func open():
	menu_container.hide()
	#var stylebox = StyleBoxFlat.new()
	#menu_container.add_theme_stylebox_override("normal", stylebox)
	magical_scroll.play()
	await magical_scroll.animation_finished
	#var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	#tween.tween_property()
	menu_container.show()
	start_timer()

func close():
	menu_container.hide()
	magical_scroll.play_backwards()
	await magical_scroll.animation_finished
	return true

func start_timer() -> void:
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_label.text = "%d s" % timer.time_left

func _start_game():
	Globals.change_gamemode(Globals.GAMEMODE.BUILDER)
	# this may be fired twice (if timer skipped)
	if timer.time_left > 0:
		timer.stop()
	# start game here (timer etc)
	await close()
	visible = false
