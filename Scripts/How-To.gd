extends Control

var count = 1

func _ready():
	self.show()
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($BlackCube,"modulate",Color(1,1,1,0),2)

func _on_Next_pressed():
	if count != 6:
		get_node("Panel/Part" + str(count)).hide()
		count += 1
		get_node("Panel/Part" + str(count)).show()
		$Panel/Part.text = str(count)
	else:
		self.hide()
		get_tree().paused = false
