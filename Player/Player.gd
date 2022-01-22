extends KinematicBody

export var speed = 10
export var acceleration = 10
export var gravity = 0.98
export var jump_power = 20
export var mouse_senseitivity = 0.3

onready var head = $Head
onready var camera = $Head/Camera

var velocity = Vector3()
var camera_x_rotation = 0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(deg2rad(-event.relative.x * mouse_senseitivity))
		var x_delta = event.relative.y * mouse_senseitivity
		if camera_x_rotation + x_delta > -90 and camera_x_rotation + x_delta < 90:
			camera.rotate_x(deg2rad(-event.relative.y * mouse_senseitivity))
			camera_x_rotation += x_delta

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var head_basis = head.get_global_transform().basis
	
	var direction = Vector3()
	if Input.is_action_pressed("Move_forward"):
		direction -= head_basis.z
	elif Input.is_action_pressed("Move_backwards"):
		direction += head_basis.z
	
	if Input.is_action_pressed("Move_left"):
		direction -= head_basis.x
	elif Input.is_action_pressed("Move_right"):
		direction += head_basis.x
	
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity.y -= gravity
	velocity = move_and_slide(velocity, Vector3.UP)
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y += jump_power
