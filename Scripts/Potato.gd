extends Node2D

var growth = 0
onready var burner = get_tree().current_scene.get_node("Burner")
onready var tile_map_to_check = get_tree().current_scene.get_node("Terrain")
onready var tile = tile_map_to_check.world_to_map(position)
onready var tile_info = tile_map_to_check.get_cellv(tile)

func _ready():
	randomize()
	var color_rnd = rand_range(0.81,1.0)
	modulate = Color(color_rnd,color_rnd,color_rnd,1.0)
	$Sprite.hide()

func _on_Timer_timeout():
	var tile = tile_map_to_check.world_to_map(position)
	var tile_info = tile_map_to_check.get_cellv(tile)
	if tile_info == 4 and visible:
		growth += 1
		if growth == 10:
			$Sprite.show()
		elif growth == 35:
			$Sprite.frame = 1
		elif growth == 80:
			tile_map_to_check.set_cellv(tile,1)
			$Sprite.material.set("shader_param/shine_speed",1)
			$Sprite.frame = 2


func _on_UntilAppear_timeout():
	$Sprite.show()
	tile_map_to_check.set_cellv(tile,4)
	

func _on_Area2D_body_entered(body):
	if body.name == "Player" and growth >= 80:
		body.pickable_potato = self
		body.get_node("Label2").show()


func _on_Area2D_body_exited(body):
	if body.name == "Player":
		body.pickable_potato = null
		body.get_node("Label2").hide()

func take_damage(damage):
	growth -= damage
	if growth < 0:
		burner.set_cellv(tile,-1)
		queue_free()
		Global.eaten_potatoes += 1
