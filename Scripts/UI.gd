extends CanvasLayer

func highlight_item(item_name):
	for item in $Inventory.get_children():
		if item.name != item_name:
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(item,"rect_scale",Vector2(1,1),0.5)
		else:
			var tween = create_tween()
			tween.set_trans(Tween.TRANS_CUBIC)
			tween.tween_property(item,"rect_scale",Vector2(1.25,1.25),0.2)

func update_counter(amount_of_potatoes):
	$AmountOfPotatoes.text = str(amount_of_potatoes)+"/25"
	if $AmountOfPotatoes.text == "25/25":
		get_tree().paused = true
		var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
		tween.set_pause_mode(SceneTreeTween.TWEEN_PAUSE_PROCESS)
		tween.tween_property($Win,"modulate",Color(1,1,1,1),2)
		yield(tween,"finished")
		get_tree().paused = false
		get_tree().change_scene("res://Scenes/WinScreen.tscn")
		
