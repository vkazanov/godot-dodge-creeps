## Main class connecting everything.
extends Node

@export var mob_scene: PackedScene
var score

var min_velocity = Global.INIT_MIN_SPEED
var max_velocity = Global.INIT_MAX_SPEED


func _process(delta: float) -> void:
	if Input.is_action_pressed("quit_game"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()


func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.hide_score()
	$HUD.show_game_over(score)


func new_game():
	get_tree().call_group("mobs", "queue_free")

	score = 0
	$MobTimer.wait_time = Global.MOB_CREATION

	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score, false)
	$HUD.show_message("Get Ready")


func _on_mob_timer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction

	# Choose the velocity
	var velocity = Vector2(randf_range(min_velocity, max_velocity), 0.0)
	mob.linear_velocity = velocity.rotated(direction)

	# Spawn the mob by adding it to the Main scene.
	add_child(mob)


func _on_score_timer_timeout():
	score += 1
	var is_speedup: bool = score % 5 == 0 and score != 0
	if is_speedup:
		max_velocity *= Global.SPEEDUP
		$MobTimer.wait_time *= Global.MOB_CREATION_SPEEDUP

	$HUD.update_score(score, is_speedup)


func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()
