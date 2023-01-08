extends Sprite

onready var tile_map_to_check = get_tree().current_scene.get_node("Terrain")

var not_placable_tiles = [-1,1]
var velocity = Vector2.ZERO

func _process(delta):
	if visible:
		if Input.is_action_just_pressed("use"):
			var rotation_my = 0
			if get_parent().scale.y == 1:
				rotation_my = 80.0
			elif get_parent().scale.y == -1:
				rotation_my = -80.0
			var hit_point_pos = $HitPoint.global_position
			var tile = tile_map_to_check.world_to_map(hit_point_pos)
			var tile_info = tile_map_to_check.get_cellv(tile)
			if tile_info == 0:
				randomize()
				$sfx.pitch_scale = rand_range(1.5,1.6)
				$sfx.play()
				var tween = create_tween()
				tween.set_trans(Tween.TRANS_CIRC)
				tween.tween_property(self,"rotation_degrees",115.0,0.1)
				tween.tween_property(self,"rotation_degrees",90.0,0.3)
				tile_map_to_check.set_cellv(tile,1)

#func _input(event):
#	if visible:
#		if event is InputEventMouseButton and event.pressed:
#			var hit_point_pos = $HitPoint.global_position
#			var tile = tile_map_to_check.world_to_map(hit_point_pos)
#			var tile_info = tile_map_to_check.get_cellv(tile)
#			if tile_info != -1:
#				tile_map_to_check.set_cellv(tile,1)
