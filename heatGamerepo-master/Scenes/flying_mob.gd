extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var speed: float = 10
var change_animation_timer := 0.0
var change_interval := 5

signal next_round

var area_margin := 10.0

func _ready():
	input_pickable = true
	velocity = _random_direction() * speed
	sprite.play("fly_forward")

func _random_direction():
	var x = deg_to_rad(randf_range(0,180))
	return Vector2(cos(x), sin(x)).normalized()

func _physics_process(delta):
	_move_enemy(delta)
	_check_bounds()
	_check_direction()
	_update_animation(delta)

func _move_enemy(delta):
	if sprite.animation == "going_up":
		position.y -= speed * delta
	else:
		position += velocity * delta

func _check_bounds():
	var viewport = get_viewport_rect()
	
	if sprite.animation == "going_up":
		if position.y < area_margin:
			sprite.play("fly_forward")
			velocity.y = abs(velocity.y)
		elif position.y > viewport.size.y - area_margin:
			sprite.play("fly_forward")
			velocity.y = -abs(velocity.y)
	else:
		if position.x < area_margin:
			velocity.x = abs(velocity.x)
			if randi() % 2 == 0:
				sprite.play("going_up")
		elif position.x > viewport.size.x - area_margin:
			velocity.x = -abs(velocity.x)
			if randi() % 2 == 0:
				sprite.play("going_up")
		if position.y < area_margin:
			velocity.y = abs(velocity.y)
			sprite.play("fly_forward")
		elif position.y > viewport.size.y - area_margin:
			velocity.y = -abs(velocity.y)
			sprite.play("fly_forward")

func _check_direction():
	sprite.flip_h = velocity.x < 0

func _update_animation(delta):
	change_animation_timer += delta
	if change_animation_timer >= change_interval:
		change_animation_timer = 0
		if sprite.animation != "death":
			if randi() % 2 == 0:
				sprite.play("going_up")
			else:
				sprite.play("fly_forward")

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event.is_action_pressed("shoot"):
		death()

func death():
	velocity = Vector2.ZERO
	animation_player.play("death")
	await get_tree().create_timer(1).timeout
	next_round.emit()  # <- emitir señal al morir
	queue_free()
