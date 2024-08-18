extends Label

@export var success_particles: GPUParticles2D
@export var audio_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.new_height_reached.connect(new_height_reached)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_height_reached() -> void:
	success_particles.emitting = true
	#audio_player.play()
