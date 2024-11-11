extends CharacterBody2D

@onready var main: Node2D = get_node("/root/Main")
@onready var target: Node2D = get_node("/root/Main/Player")

var explosion_scene := preload("res://Field/Explosion/Explosion.tscn")
var item_scene := preload("res://Field/Item/Item.tscn")

signal hit_player

var entered: bool
var alive: bool
var speed: int
var direction: Vector2

func die():
	# Animate
	alive = false
	$AnimatedSprite2D.play("die")
	$Threat/CollisionShape2D.set_deferred("disabled", true)
	 	# $Timer.wait_time = $AnimatedSprite2D.frames.get_frame_count() / $AnimatedSprite2D.frames.get_animation_length("die")
	$Despawn.wait_time = 3
	$Despawn.start()

	# Drop Item
	var item = item_scene.instantiate()
	item.position = position
	main.call_deferred("add_child", item)
	item.add_to_group("items")

	# Explosion
	var explosion = explosion_scene.instantiate()
	explosion.position = position
	explosion.process_mode = Node.PROCESS_MODE_ALWAYS
	main.add_child(explosion)

func _ready():
	entered = false
	alive = true
	speed = 80

	var screen_rect = get_viewport_rect()
	var distance = screen_rect.get_center() - position

	if abs(distance.x) > abs(distance.y):
		direction = Vector2(distance.x, 0)
	else:
		direction = Vector2(0, distance.y)


func _physics_process(_delta):
	if alive:
		if speed < 195:
			speed += (speed / 180)

		if entered:
			direction = target.position - position
		velocity = direction.normalized() * speed
		move_and_slide()

		# Animation
		if velocity.x != 0:
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		pass

func _on_entrance_timer_timeout():
	if (position.y > 0 && position.x > 0 && position.x < get_viewport_rect().size.x && position.y < get_viewport_rect().size.y):
		entered = true
	else:
		if !entered:
			direction = (direction * -1) + (target.position - position).normalized()

func _on_threat_body_entered(_body:Node2D):
	emit_signal("hit_player")

func _on_despawn_timeout():
	queue_free()
