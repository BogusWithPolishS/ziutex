extends CharacterBody2D
var grav:float = 800
var jumpForce:float = 400
var timeJumping:float = 0
var canJump:bool = true
var speed:float = 50
var dir:int = 1 #1 = right; -1 = left
var moving:bool = false
@onready var door:StaticBody2D = get_parent().get_node("Door")
@onready var doorArea: Area2D = door.get_node("Area2D")
@onready var spriteAnim = $AnimatedSprite2D
@onready var console = get_parent().get_node_or_null("Label")
@onready var tree = get_tree()
const MAX_TIME_JUMPING:float = 0.8
const MAX_SPEED:float = 400

func _ready() -> void:
	doorArea.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		get_tree().call_deferred("change_scene_to_file", Globals.nextLVL)


func _physics_process(delta: float) -> void:
	# GRAVITY ################################
	velocity.y += grav * delta
	if !is_on_floor():
		timeJumping += delta
		Globals.plrFloating = true
	else:
		timeJumping = 0
		canJump = true
		Globals.plrFloating = false
	############################################
		
	# JUMP ##################################
	if Input.is_action_pressed("ui_up"):
		if canJump:
			velocity.y = -jumpForce + timeJumping * 100
			
			if timeJumping >= MAX_TIME_JUMPING:
				canJump = false
	else:
		canJump = false
		
	# MOVE ####################################
	if Input.is_action_pressed("left_right"):
		moving = true
		if Input.is_action_pressed("ui_left"):
			dir = -1
			spriteAnim.flip_h = false
		if Input.is_action_pressed("ui_right"):
			dir = 1
			spriteAnim.flip_h = true
			
		velocity.x += speed * dir
		velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	else:
		velocity.x = 0
		moving = false
	###########################################
	if !moving && is_on_floor():
		spriteAnim.play("idle")
	elif moving && is_on_floor():
		spriteAnim.play("walk")
	elif !is_on_floor():
		spriteAnim.play("falling")
		
	move_and_slide()
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var other = collision.get_collider()
		if other.name == "SpikeLayer":
			tree.reload_current_scene()
