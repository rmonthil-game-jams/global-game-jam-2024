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
	pigeon_forearm = pigeon.get_node("ForearmLeft")
	pigeon_impulse_anchor = pigeon_forearm.get_node("Marker2DAnchorLeft")

func _input(event: InputEvent):
	if event is InputEventJoypadButton:
		if event.device == 0:
			match event.button_index:
				JOY_BUTTON_A:
					if event.pressed:
						if pigeon.state_left == "idle":
							pigeon.hit_left()
				JOY_BUTTON_B:
					if event.pressed:
						if pigeon.state_left == "idle":
							pigeon.hit_left()
				JOY_BUTTON_X:
					if event.pressed:
						if pigeon.state_left == "idle":
							pigeon.hit_left()
				JOY_BUTTON_Y:
					if event.pressed:
						if pigeon.state_left == "idle":
							pigeon.hit_left()

func _physics_process(delta: float):
	direction = Vector2.ZERO
	direction.x = Input.get_joy_axis(0, JOY_AXIS_LEFT_X)
	direction.y = Input.get_joy_axis(0, JOY_AXIS_LEFT_Y)
	if direction and direction.length() > 0.5:
		#direction = direction.normalized()
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

func _get_velocity_control_impulse(dir: Vector2, delta: float) -> Vector2:
	return pigeon_forearm.mass * (dir * TARGET_VELOCITY - pigeon_forearm.linear_velocity) * delta / REACTION_TIME
