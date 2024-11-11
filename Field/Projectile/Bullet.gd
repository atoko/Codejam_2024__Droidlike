extends Area2D

var speed: int
var direction: Vector2

func _ready():
	speed = 800

func _physics_process(delta):
	if speed > 200:
		speed -= 1

	position += speed * delta * direction

func _on_despawn_timeout():
	queue_free()


func _on_body_entered(body:Node2D):
	if (body.name == "Bushes"):
		queue_free()
	else:
		if (body.alive):
			body.die()
			queue_free()
