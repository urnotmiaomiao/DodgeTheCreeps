extends Node2D


export (PackedScene) var Mob
var score


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
#	new_game()


func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			get_tree().quit()
	
func game_over():
	$Music.stop()
	$DeathSound.play()
	$ScoreTimer.stop()
	$MobTimer.stop()
	get_tree().call_group("mobs", "queue_free")
	

func new_game():
	$Music.play()
	score = 0
	$HUD.update_score(score)
	$HUD.show_messsage("Get Ready")
	$Player.start($StartPosition.position)
	$StartTimer.start() 


func _on_Player_hit():
	game_over()
	$HUD.show_game_over()
	pass
	
	
func _on_MobTimer_timeout():
	$MobPath/MobSpawnLocation.offset = randi()
	var mob = Mob.instance()
	add_child(mob)
	var direction = $MobPath/MobSpawnLocation.rotation + PI / 2
	mob.position = $MobPath/MobSpawnLocation.position
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	mob.linear_velocity = Vector2(rand_range(mob.min_speed, mob.max_speed), 0)
	mob.linear_velocity = mob.linear_velocity.rotated(direction)


func _on_ScoreTimer_timeout():
	score += 1
	$HUD.update_score(score)


func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()


func _on_HUD_start_game():
	new_game()
