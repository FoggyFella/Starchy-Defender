extends Sprite

var potato = preload("res://Scenes/Potato.tscn")
var empty_texture = preload("res://Assets/water_bucket_empty.png")
var full_texture = preload("res://Assets/watering_can.png")

onready var burner_tilemap = get_tree().current_scene.get_node("Burner")
onready var tile_map_to_check = get_tree().current_scene.get_node("Terrain")

var not_placable_tiles = [-1,0,4,3]

func _process(delta):
	if visible:
		if Input.is_action_pressed("use") and get_parent().get_parent().water_charges != 0:
			var hit_point_pos = $HitPoint.global_position
			var tile = tile_map_to_check.world_to_map(hit_point_pos)
			var tile_info = tile_map_to_check.get_cellv(tile)
			if !tile_info in not_placable_tiles:
				randomize()
				if tile_info == 1:
					$sfx.pitch_scale = rand_range(1.5,1.6)
					$sfx.play()
					if get_parent().get_parent().should_spend_water:
						get_parent().get_parent().water_charges -= 1
						if get_parent().get_parent().water_charges == 0:
							texture = empty_texture
						get_parent().get_parent().get_node("Label").text = str(get_parent().get_parent().water_charges) +"/5"
					tile_map_to_check.set_cellv(tile,4)
					animate()
					var timer = get_tree().create_timer(rand_range(10,20))
					timer.connect("timeout",self,"dry",[tile])
				elif tile_info == 2:
					$sfx.pitch_scale = rand_range(1.5,1.6)
					$sfx.play()
					if get_parent().get_parent().should_spend_water:
						get_parent().get_parent().water_charges -= 1
						if get_parent().get_parent().water_charges == 0:
							texture = empty_texture
						get_parent().get_parent().get_node("Label").text = str(get_parent().get_parent().water_charges) +"/5"
					tile_map_to_check.set_cellv(tile,3)
					grow(tile)
					animate()
					var timer = get_tree().create_timer(rand_range(10,20))
					timer.connect("timeout",self,"dry",[tile])

func dry(tile):
	var tile_info = tile_map_to_check.get_cellv(tile)
	if tile_info == 3:
		tile_map_to_check.set_cellv(tile,2)
	elif tile_info == 4:
		tile_map_to_check.set_cellv(tile,1)

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
	tween.tween_property(self,"rotation_degrees",40.0,0.25)
	tween.tween_property(self,"rotation_degrees",0.0,0.25)
