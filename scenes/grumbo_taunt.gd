extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var grumbo_text = ["Ha Ha!", "Okay, I'll leave the village alone...", "If you can scale the tower higher than ME!!"];
	$".".add_text(grumbo_text[0]);
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
