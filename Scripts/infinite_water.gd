extends Area2D

func _on_WaterPickup_body_entered(body):
	if body.name == "Player":
		body.activate_inf_water()
		queue_free()
