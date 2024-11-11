extends Node2D

@export var bullet_scene: PackedScene

func _on_player_shoot(from: Vector2, aim: Vector2):
	print("Player shoots")
	var bullet = bullet_scene.instantiate()
	bullet.position = from
	bullet.direction = aim.normalized()
	add_child(bullet)
	bullet.add_to_group("bullets")	
