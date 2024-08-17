class_name ScoreboardEntry extends HBoxContainer

@export var username: String = "loading..."
@export var username_label: Label
@export var score: String = "loading..."
@export var score_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	username_label.text = username
	score_label.text = score
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
