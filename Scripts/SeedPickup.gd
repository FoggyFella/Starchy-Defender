extends Area2D

func _on_SeedPickup_body_entered(body):
	if body.name == "Player":
		queue_free()
		body.seeds += 1
		if body.get_node("ToolRoot/Seeds").visible:
			body.get_node("Label").text = str(body.seeds)
			body.get_node("Label").show()
