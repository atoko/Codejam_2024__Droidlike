extends Node2D

@onready var main = get_node("/root/Main")

signal hit_p

var prototype := preload("res://Field/Enemy/Enemy.tscn")
var spawn_rate := 1.0
var spawn_points := []

func _ready():
	for child in get_children():
		if child is Marker2D:
			spawn_points.append(child.position)
	$Timer.wait_time = spawn_rate
	$Timer.start()

func _on_timer_timeout():
	var spawn = spawn_points[randi() % spawn_points.size()]
	var enemy = prototype.instantiate()
	enemy.position = spawn
	enemy.hit_player.connect(_on_enemy_hit_player)
	main.add_child(enemy)
	enemy.add_to_group("enemies")

func _on_enemy_hit_player():
	hit_p.emit()
