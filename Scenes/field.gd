extends Node2D
@onready var bullet_node: Label = $CanvasLayer/bullet
@onready var Round_node: Label = $CanvasLayer/round
@onready var score_node: Label = $CanvasLayer/score


var bullet_count = 3:
	set(value):
		if value>=0:
			bullet_count = value
			bullet_node.text = str(value)
		else:
			_lose()
			
var Round = 1:
	set(value):
		Round = value
		Round_node.text = str(value)
		
var score = 0:
	set(value):
		score = value
		score_node.text = str(value)

@export var flying_mob_node: PackedScene
var flying_mob

func _ready():
	_default_display()
	_spawn_enemy()

func _default_display():
	bullet_node.text = str(bullet_count)
	Round_node.text = str(Round)
	score_node.text = str(score)
	
	
func _spawn_enemy():
	if flying_mob != null:
		await flying_mob.tree_exited
	flying_mob = flying_mob_node.instantiate()
	
	flying_mob.speed = Round * 30
	flying_mob.position = Vector2(160,90)
	flying_mob.next_round.connect(_on_next_round)
	flying_mob.call_deferred("set_name", "flying mob")
	
	get_tree().current_scene.add_child(flying_mob)
	
func _on_next_round():
	score += Round * 100
	Round +=1
	bullet_count = 5
	
	_spawn_enemy()
	
#shooting count

func _input(event):
	if event.is_action_pressed("shoot"):
		bullet_count -=1

func _lose():
	if $Timer.is_stopped():
		find_child("Laugh_mob").dog_laugh()
		find_child("flying_mob", false, false).input_pickable = false
		$Timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
