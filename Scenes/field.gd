extends Node2D
@onready var bullet_node: Label = $CanvasLayer/bullet
@onready var round_node: Label = $CanvasLayer/round
@onready var score_node: Label = $CanvasLayer/score


var bullet_count = 3:
	set(value):
		if value>=0:
			bullet_count = value
			bullet_node.text = str(value)
			
var round = 1:
	set(value):
		round = value
		round_node.text = str(value)
		
var score = 0:
	set(value):
		score = value
		score_node.text = str(value)

@export var flying_mob_node: PackedScene
var flying_mob

func _ready():
	_default_display()

func _default_display():
	bullet_node.text = str(bullet_count)
	round_node.text = str(round)
	score_node.text = str(score)
