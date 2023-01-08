extends Sprite

onready var tile_map_to_check = get_tree().current_scene.get_node("Terrain")
onready var burner_tilemap = get_tree().current_scene.get_node("Burner")

var potato = preload("res://Scenes/Potato.tscn")
var not_placable_tiles = [-1,0]

func _process(delta):
	if visible:
		if Input.is_action_pressed("use") and get_parent().get_parent().seeds != 0:
			var hit_point_pos = $HitPoint.global_position
			var tile = tile_map_to_check.world_to_map(hit_point_pos)
			var tile_info = tile_map_to_check.get_cellv(tile)
			var tile_info_burner = burner_tilemap.get_cellv(tile)
			randomize()
			if tile_info == 1 and tile_info_burner != 0:
				$sfx.pitch_scale = rand_range(1.5,1.6)
				$sfx.play()
				get_parent().get_parent().seeds -= 1
				get_parent().get_parent().get_node("Label").text = str(get_parent().get_parent().seeds)
				tile_map_to_check.set_cellv(tile,2)
				animate()
			elif tile_info == 4 and tile_info_burner != 0:
				$sfx.pitch_scale = rand_range(1.5,1.6)
				$sfx.play()
				get_parent().get_parent().seeds -= 1
				get_parent().get_parent().get_node("Label").text = str(get_parent().get_parent().seeds)
				tile_map_to_check.set_cellv(tile,3)
				animate()
				grow(tile)

func grow(tile):
	var potato_inst = potato.instance()
	var tile_info = tile_map_to_check.get_cellv(tile)
	burner_tilemap.set_cellv(tile,0)
	potato_inst.position = tile_map_to_check.map_to_world(tile)
	potato_inst.position.x += 32
	potato_inst.position.y += 15
	get_tree().current_scene.get_node("Potatoes").add_child(potato_inst)

func animate():
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self,"rotation_degrees",65.0,0.1)
	tween.tween_property(self,"rotation_degrees",90.0,0.1)
