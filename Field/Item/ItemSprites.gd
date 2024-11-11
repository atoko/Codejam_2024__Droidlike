extends Area2D

var item_type: int

var coffee_box := preload("res://Field/Item/_Coffee_Box.tres")
var turkey := preload("res://Field/Item/_Turkey.tres")
var textures = [coffee_box, turkey]

func _ready():
	item_type = randi_range(0, textures.size() - 1)
	$Sprite2D.texture = textures[item_type]


func _on_body_entered(body:Node2D):
	if (body.name == "Player"):
		# body.collect_item(item_type)
		print_debug("Player collected item " + str(item_type))
		queue_free()
	else:
		pass
