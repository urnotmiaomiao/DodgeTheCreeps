extends Area2D


export var speed = 400	
# "export" allows its value being changed in Inspector
var screen_size
var _isTouchControl = false
var target
signal hit


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	screen_size = get_viewport_rect().size

func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		_isTouchControl = true
		target = event.position


func _process(delta):
	var velocity = Vector2()
	if _isTouchControl:
		velocity = (target - position)
	else:
		if Input.is_action_pressed("ui_right"):
			velocity.x += 1
		if Input.is_action_pressed("ui_left"):
			velocity.x -= 1
		if Input.is_action_pressed("ui_up"):
			velocity.y -=1
		if Input.is_action_pressed("ui_down"):
			velocity.y +=1
		velocity = velocity.normalized() * speed
	if velocity.length() > 0:
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		$AnimatedSprite.flip_v = false
		$AnimatedSprite.flip_h = velocity.x < 0
	elif velocity.y !=0:
		$AnimatedSprite.animation = "up"
		$AnimatedSprite.flip_v = velocity.y >0

func _on_Player_body_entered(body):
	hide()
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

