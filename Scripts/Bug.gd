extends KinematicBody2D

var damage = 2
onready var potato_root = get_tree().current_scene.get_node("Potatoes")
onready var player = get_tree().current_scene.get_node("YSort/Player")
var blood = preload("res://Scenes/bug_blood.tscn")
var pickups = {
	1 : preload("res://Scenes/SeedPickup.tscn"),
	2 : preload("res://Scenes/infinite_water.tscn")
}

enum States {
	SEARCHING,
	MUNCHING,
	WALKING,
}

var percentages = [0.9,0.1]
var can_munch = true
var speed = 40
var min_distance = 99999999.0
var target = null
var velocity = Vector2.ZERO
var current_state = States.SEARCHING


func _ready():
	randomize()
	speed = rand_range(35.0,50.0)

func _physics_process(delta):
	match current_state:
		States.SEARCHING:
			$AnimatedSprite.stop()
			if target == null:
				if potato_root.get_child_count() != 0:
					for potato in potato_root.get_children():
						var distance = global_position.distance_to(potato.global_position)
						if distance < min_distance:
							min_distance = distance
							target = potato
					min_distance = 99999999.0
					if target != null:
						change_state(States.WALKING)
				else:
					if $Timer.is_stopped():
						target = null
						min_distance = 99999999.0
						$Timer.start()
		States.MUNCHING:
			$AnimatedSprite.stop()
			if target != null and can_munch:
				can_munch = false
				$munch_rate.start()
				if get_node_or_null(get_path_to(target)) != null:
					target.take_damage(damage)
				else:
					target = null
					print("let's search")
					change_state(States.SEARCHING)
		States.WALKING:
			$AnimatedSprite.play("default")
			if target != null:
				if get_node_or_null(get_path_to(target)) != null:
					velocity = global_position.direction_to(target.global_position).normalized() * speed
					look_at(target.global_position)
					move_and_slide(velocity,Vector2.UP)
					if global_position.distance_to(target.global_position) < 1:
						change_state(States.MUNCHING)
				else:
					target = null
					change_state(States.SEARCHING)

func change_state(next_state):
	current_state = next_state


func _on_munch_rate_timeout():
	can_munch = true


func _on_Timer_timeout():
	if potato_root.get_child_count() != 0:
		print("haha")
	else:
		$Timer.start()

func die():
	queue_free()
	get_random_pickup()
	var blood_inst = blood.instance()
	blood_inst.global_position = global_position
	blood_inst.rotation = global_position.angle_to_point(player.global_position)
	get_tree().current_scene.add_child(blood_inst)

func get_random_pickup():
	var rng = RandomNumberGenerator.new()
	randomize()
	rng.randomize()
	var chance = rand_range(0, 100)
	if chance < 10:
		var pick_up_inst = pickups[rng.randi_range(1,2)].instance()
		pick_up_inst.global_position = self.global_position
		get_tree().current_scene.add_child(pick_up_inst)

