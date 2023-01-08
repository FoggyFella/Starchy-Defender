extends Area2D

var active = false
onready var player = get_tree().current_scene.get_node("YSort/Player")

func _on_Well_body_entered(body):
	if body.name == "Player":
		player.get_node("Label3").show()
		active = true


func _on_Well_body_exited(body):
	if body.name == "Player":
		player.get_node("Label3").hide()
		active = false

func _input(event):
	if event.is_action_pressed("harvest") and active:
		if player.should_spend_water:
			player.water_charges = 5
			player.get_node("ToolRoot").get_node("Can").texture = player.get_node("ToolRoot").get_node("Can").full_texture
			if player.get_node("ToolRoot").get_node("Can").visible:
				player.get_node("Label").text = str(player.water_charges) + "/5"
