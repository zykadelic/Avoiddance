extends Node

export(PackedScene) var mob_scene
var score: int

func _ready():
	randomize()

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()

func new_game():
	score = 0
	$HUD.update_score(score)
	get_tree().call_group("mobs", "queue_free")

	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("5, 6, 7, 8!")
	$Music.play()

func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_MobTimer_timeout():
	var mob: Node = mob_scene.instance()

	# randomise a spawn point along the path
	var mob_spawn_location := get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	mob.position = mob_spawn_location.position

	# face the mob in a random direction, within 180deg inwards to the scene
	var direction: float = mob_spawn_location.rotation + PI / 2
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# randomise movement speed
	var velocity := Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# spawn
	add_child(mob)
