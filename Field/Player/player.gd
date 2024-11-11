extends CharacterBody2D

signal shoot

var screen_size: Vector2
var current_animation: StringName
var speed: int
var can_shoot: bool = true

func _ready():
	screen_size = get_viewport_rect().size
	current_animation = "idle"
	speed = 200

func _physics_process(_delta):
	# Movement
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_dir.normalized() * speed
	move_and_slide()
	position = position.clamp(Vector2(0, 0), screen_size)

	# Buttons
	# Check config, we will support click aiming and joystick aiming
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and can_shoot:
		var direction = get_global_mouse_position() - position
		shoot.emit(position, direction)
		can_shoot = false
		$Cooldown.start()

	# Direction
	var mouse = get_local_mouse_position()
	var angle = snappedf(mouse.angle(), PI / 4) / (PI / 4)

	# Animation
	angle = wrapi(int(angle), 0, 8)
	var previous_animation = current_animation
	if velocity.length() > 0:
		current_animation = "walk" + str(angle)
	else:
		current_animation = "idle"

	if previous_animation != current_animation:
		$AnimatedSprite2D.frame = 0
		$AnimatedSprite2D.animation = current_animation
		$AnimatedSprite2D.play()

	if (position.x - mouse.x) > 0:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

func _on_cooldown_timeout():
	can_shoot = true
	