extends Node

# parameters

@export var TARGET_VELOCITY: float
@export var REACTION_TIME: float

# to set

@export_node_path("Node2D") var pigeon_path: NodePath

# internal

var direction: Vector2 = Vector2.ZERO

var pigeon: Node2D
var pigeon_body: RigidBody2D
var pigeon_forearm: RigidBody2D
var pigeon_impulse_anchor: Marker2D

func _ready():
	pigeon = get_node(pigeon_path)
	pigeon_body = pigeon.get_node("Body")
	pigeon_forearm = pigeon.get_node("ForearmRight")
	pigeon_impulse_anchor = pigeon_forearm.get_node("Marker2DAnchorRight")

func _input(event: InputEvent):
	if event is InputEventKey:
		if not event.is_echo():
			match event.physical_keycode:
				KEY_O:
					if event.pressed:
						if pigeon.state_right == "idle":
							pigeon.hit_right()
				KEY_U:
					if event.pressed:
						if pigeon.state_right == "idle":
							pigeon.hit_right()
				KEY_ENTER:
					if event.pressed:
						if pigeon.state_right == "idle":
							pigeon.hit_right()

func _physics_process(delta: float):
	direction = Vector2.ZERO
	if Input.is_physical_key_pressed(KEY_UP) or Input.is_physical_key_pressed(KEY_I):
		direction.y -= 1.0
	if Input.is_physical_key_pressed(KEY_RIGHT) or Input.is_physical_key_pressed(KEY_L):
		direction.x += 1.0
	if Input.is_physical_key_pressed(KEY_LEFT) or Input.is_physical_key_pressed(KEY_J):
		direction.x -= 1.0
	if Input.is_physical_key_pressed(KEY_DOWN) or Input.is_physical_key_pressed(KEY_K):
		direction.y += 1.0
	if direction:
		direction = direction.normalized()
		var impulse: Vector2 = _get_velocity_control_impulse(direction, delta)
		match pigeon.state_right:
			"idle":
				pigeon_forearm.apply_impulse(impulse, pigeon_impulse_anchor.global_position - pigeon_forearm.global_position)
				pigeon_body.apply_impulse(-0.5*impulse)
			"hitting":
				pigeon_forearm.apply_impulse(impulse, pigeon_impulse_anchor.global_position - pigeon_forearm.global_position)
				pigeon_body.apply_impulse(-0.5*impulse)
			"cooling":
				pigeon_forearm.apply_impulse(impulse, pigeon_impulse_anchor.global_position - pigeon_forearm.global_position)
				pigeon_body.apply_impulse(-0.5*impulse)
			"holding":
				pigeon_body.apply_impulse(-impulse)
	else:
		var impulse: Vector2 = _get_velocity_control_impulse(Vector2.ZERO, delta)
		pigeon_forearm.apply_impulse(0.5 * impulse)

func _get_velocity_control_impulse(direction: Vector2, delta: float) -> Vector2:
	return pigeon_forearm.mass * (direction * TARGET_VELOCITY - pigeon_forearm.linear_velocity) * delta / REACTION_TIME
