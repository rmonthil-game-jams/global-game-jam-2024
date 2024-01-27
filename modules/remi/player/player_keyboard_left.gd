extends Node

# parameters

@export var TARGET_VELOCITY: float
@export var REACTION_TIME: float

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
	pigeon_forearm = pigeon.get_node("ForearmLeft")
	pigeon_impulse_anchor = pigeon_forearm.get_node("Marker2DAnchorLeft")

func _input(event: InputEvent):
	if event is InputEventKey:
		if not event.is_echo():
			match event.physical_keycode:
				KEY_W:
					if event.pressed:
						direction.y -= 1.0
					else:
						direction.y += 1.0
				KEY_D:
					if event.pressed:
						direction.x += 1.0
					else:
						direction.x -= 1.0
				KEY_A:
					if event.pressed:
						direction.x -= 1.0
					else:
						direction.x += 1.0
				KEY_S:
					if event.pressed:
						direction.y += 1.0
					else:
						direction.y -= 1.0
				KEY_X:
					if event.pressed:
						if pigeon.state_left == "idle":
							pigeon.state_left = "holding"
							pigeon_forearm.freeze = true
					else:
						if pigeon.state_left == "holding":
							pigeon.state_left = "idle"
							pigeon_forearm.freeze = false
				KEY_C:
					if event.pressed:
						if pigeon.state_left == "idle":
							pigeon.state_left = "hitting"
							pigeon.get_node("TimerHitLeft").start()

func _physics_process(delta: float):
	if direction:
		var impulse: Vector2 = _get_velocity_control_impulse(direction, delta)
		match pigeon.state_left:
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