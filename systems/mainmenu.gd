extends Control

@export var magical_scroll: AnimatedSprite2D
@export var menu_container: HBoxContainer
@export var button_play: BaseButton
@export var menu_tutorial: Control
@export var textedit_username: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	open()
	button_play.pressed.connect(self._play)
	textedit_username.text_changed.connect(self._name_updated)
	if textedit_username.text != "":
		button_play.disabled = false
	pass # Replace with function body.

func open():
	menu_container.hide()
	#var stylebox = StyleBoxFlat.new()
	#menu_container.add_theme_stylebox_override("normal", stylebox)
	magical_scroll.play()
	await magical_scroll.animation_finished
	#var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
	#tween.tween_property()
	menu_container.show()

func close():
	menu_container.hide()
	magical_scroll.play_backwards()
	await magical_scroll.animation_finished
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _play():
	await close()
	self.visible = false
	if menu_tutorial != null:
		menu_tutorial.visible = true
		menu_tutorial.open()

func _name_updated(newtext: String):
	if newtext == "":
		button_play.disabled = true
	else:
		button_play.disabled = false
