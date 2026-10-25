extends CharacterBody2D
var dir:int = 1
var speed:float = 100
@onready var plr = get_parent().get_node("Player")
@onready var console:Label = get_parent().get_node_or_null("Label")
@onready var anim = $AnimatedSprite2D
const DEFAULT_SPEED = 200
const SLOW_SPEED = 100
const MAX_TIME_JUMPING:float = 0.8
const MAX_SPEED:float = 400

func _ready() -> void:
	plr = get_parent().get_node("Player")
	anim.play("idle")
	

func _physics_process(delta: float) -> void:
	if !Globals.plrFloating:
		if Input.is_action_pressed("left_right"):
			if Input.is_action_pressed("ui_left"):
				dir = -1
			if Input.is_action_pressed("ui_right"):
				dir = 1
			velocity.x = speed * dir
		else:
			velocity.x = 0
	else:
		velocity.x = 0

	if abs(global_position.x - plr.global_position.x) < 100:
		speed = SLOW_SPEED
	else:
		speed = DEFAULT_SPEED
		
	if Globals.plrFloating:
		if Input.is_action_pressed("up_down"):
			if Input.is_action_pressed("ui_up"):
				dir = -1
			if Input.is_action_pressed("ui_down"):
				dir = 1
			velocity.y = speed * dir
		else:
			velocity.y = 0
	else:
		velocity.y = 0
		
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var other = collision.get_collider()
		if other is CharacterBody2D:
			velocity = Vector2(0, 0)
		
	
