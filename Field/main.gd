extends Node

var lives = 3

func new():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _ready():
	$Gameover.hide()
	$Gameover/Button.pressed.connect(new)

func _on_enemy_spawner_hit_p():
	lives -= 1
	$Overlay/Bottom/HBoxContainer/Lives.text = str(lives)
	if lives <= 0:
		$Gameover.show()
		get_tree().paused = true
