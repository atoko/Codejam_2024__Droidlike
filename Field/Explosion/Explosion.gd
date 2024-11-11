extends CPUParticles2D

func _ready():
	emitting = true

func _process(_delta):
	if not emitting:
		queue_free()