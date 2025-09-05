extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var speed: float = 100

func _ready():
	input_pickable = true
	velocity = _random_up_direction() * speed
	
func _random_up_direction():
	var x = deg_to_rad(randf_range(0,180))
	return Vector2(cos(x), sin(x)).normalized()
	
func _physics_process(delta):
	var col = move_and_collide(velocity * delta)
	
	if col:
		velocity = velocity.bounce(col.get_normal())
		
	_check_direction()
	
func _check_direction():
	if velocity.x <0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
		


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event.is_action_pressed("shoot"):
		#when we click the demon it gets destroyed
		queue_free()
		
