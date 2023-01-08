extends Sprite

var can_attack = true

func _process(delta):
	if visible:
		if can_attack:
			if Input.is_action_just_pressed("use"):
				$sfx1.pitch_scale = rand_range(1.5,1.6)
				$sfx1.play()
				var tween = create_tween()
				tween.set_trans(Tween.TRANS_CUBIC)
				tween.tween_property(self,"position",Vector2(40,0),0.6)
			if Input.is_action_just_released("use"):
				can_attack = false
				$reload.start()
				$sfx2.pitch_scale = rand_range(1.5,1.6)
				$sfx2.play()
				$HitBox.monitoring = true
				$HitBox.monitorable = true
				var tween = create_tween()
				tween.set_trans(Tween.TRANS_BOUNCE)
				tween.tween_property(self,"position",Vector2(65,0),0.2)
				tween.tween_property(self,"position",Vector2(53,0),0.2)
				yield(tween,"finished")
				$HitBox.monitoring = false
				$HitBox.monitorable = false

func _physics_process(delta):
	if visible and $HitBox.monitoring:
		var overlapping_bodies = $HitBox.get_overlapping_bodies()
		if !overlapping_bodies.empty():
			for body in overlapping_bodies:
				if body.is_in_group("bugs"):
					randomize()
					get_parent().get_parent().get_node("BugSplah").pitch_scale = rand_range(1.4,1.6)
					get_parent().get_parent().get_node("BugSplah").play()
					body.die()
#					get_tree().paused = true
#					yield(get_tree().create_timer(0.2),"timeout")
#					get_tree().paused = false


func _on_reload_timeout():
	can_attack = true
