extends Control

@export var button_play: Button
@export var menu_tutorial: Control
@export var textedit_username: LineEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_play.pressed.connect(self._play)
	textedit_username.text_changed.connect(self._name_updated)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _play():
	self.visible = false
	menu_tutorial.visible = true
	menu_tutorial.start_timer()

func _name_updated(newtext: String):
	if newtext == "":
		button_play.disabled = true
	else:
		button_play.disabled = false
