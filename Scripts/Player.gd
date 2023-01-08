extends KinematicBody2D

#var bug = preload("res://Scenes/Bug.tscn")

onready var burner = $"../../Burner"
onready var camera = $Camera2D
onready var spawn_points = $"../../SpawnPoints"
onready var ui = $"../../UI"

var should_spend_water = true
var picked_potatoes = 24
var velocity = Vector2()
export (int) var speed = 200
var seeds = 1
var water_charges = 5
var pickable_potato = null
var rng = RandomNumberGenerator.new()

func _ready():
	$Label.hide()
	for item in $ToolRoot.get_children():
		item.hide()

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_just_pressed("harvest") and pickable_potato != null:
		burner.set_cellv(pickable_potato.tile,-1)
		picked_potatoes += 1
		ui.update_counter(picked_potatoes)
		pickable_potato.queue_free()
		rng.randomize()
		seeds += rng.randi_range(2,3)
		$PotatoPicked.play()
		if $ToolRoot/Seeds.visible == true:
			$Label.text = str(seeds)
	velocity = velocity.normalized() * speed

#func _process(delta):
#	if get_tree().current_scene.get_node("Potatoes").get_child_count() == 0 and seeds == 0:
#		if $Backup.is_stopped():
#			$Backup.start()

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	#$ToolRoot.look_at(mouse_pos)
	$ToolRoot.rotation = lerp_angle($ToolRoot.rotation, get_angle_to(mouse_pos), 0.1)
	if get_local_mouse_position().x < -3:
		$ToolRoot.scale.y = lerp($ToolRoot.scale.y,-1.0,0.1)
	else:
		$ToolRoot.scale.y = lerp($ToolRoot.scale.y,1.0,0.1)
	camera.offset_h = (mouse_pos.x - global_position.x) / (1024 / 1.6)
	camera.offset_v = (mouse_pos.y - global_position.y) / (600 / 1.6)
	get_input()
	if velocity == Vector2.ZERO:
		$AnimatedSprite.play("Idle")
	else:
		$AnimatedSprite.play("Walk")
	get_inventory_input()
	velocity = move_and_slide(velocity)

func get_inventory_input():
	if Input.is_action_just_pressed("hoe"):
		enable_item("Hoe")
		$Label.hide()
	if Input.is_action_just_pressed("seed"):
		enable_item("Seeds")
		$Label.text = str(seeds)
		$Label.show()
	if Input.is_action_just_pressed("can"):
		enable_item("Can")
		if should_spend_water:
			$Label.text = str(water_charges) + "/5"
			$Label.show()
		else:
			$Label.text = "INF/INF"
			$Label.show()
	if Input.is_action_just_pressed("rake"):
		enable_item("Fork")
		$Label.hide()
#	if Input.is_action_just_pressed("spawn_bug"):
#		randomize()
#		var bug_inst = bug.instance()
#		var point_index = int(rand_range(0,spawn_points.get_point_count()))
#		bug_inst.global_position = spawn_points.get_point_position(point_index)
#		get_tree().current_scene.add_child(bug_inst)

func enable_item(item_name):
	ui.highlight_item(item_name)
	for item in $ToolRoot.get_children():
		if item.name != item_name:
			item.hide()
		else:
			item.show()

func _on_Backup_timeout():
	if get_tree().current_scene.get_node("Potatoes").get_child_count() == 0 and seeds == 0:
		seeds = 1

func activate_inf_water():
	$Powerup.play()
	should_spend_water = false
	water_charges = 5
	$ToolRoot/Can.texture = $ToolRoot/Can.full_texture
	$InfWaterTimer.start()
	if $ToolRoot/Can.visible:
		$Label.text = "INF/INF"
		$Label.show()

func _on_InfWaterTimer_timeout():
	water_charges = 5
	should_spend_water = true
	$ToolRoot/Can.texture = $ToolRoot/Can.full_texture
	if $ToolRoot/Can.visible:
		$Label.text = str(water_charges) + "/5"
		$Label.show()
