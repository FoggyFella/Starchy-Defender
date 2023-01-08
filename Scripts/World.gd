extends Node2D

var bug = preload("res://Scenes/Bug.tscn")
var spawn_time = 10

func spawn_bug():
	var bug_inst = bug.instance()
	var point_index = int(rand_range(0,$SpawnPoints.get_point_count()))
	bug_inst.global_position = $SpawnPoints.get_point_position(point_index)
	get_tree().current_scene.add_child(bug_inst)

func _ready():
	get_tree().paused = true
	$Timer.start(spawn_time)

func _on_Timer_timeout():
	if $Potatoes.get_child_count() != 0:
		spawn_bug()
		spawn_time -= 0.2
		if spawn_time < 3.5:
			spawn_time = 3.5
		$Timer.start(spawn_time)
	else:
		$Timer.start(spawn_time)
