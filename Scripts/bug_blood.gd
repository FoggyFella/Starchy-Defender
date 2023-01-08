extends CPUParticles2D

func _on_Timer_timeout():
	print("stop")
	self.set_process(false)
	self.set_physics_process(false)
	self.set_process_input(false)
	self.set_process_internal(false)
	self.set_process_unhandled_input(false)
	self.set_process_unhandled_key_input(false)
	$Timer2.start()


func _on_Timer2_timeout():
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(1,1,1,0),2)
	yield(tween,"finished")
	queue_free()
