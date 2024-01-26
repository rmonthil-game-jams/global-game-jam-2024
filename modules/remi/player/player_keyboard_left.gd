extends Node

# parameters

const TARGET_VELOCITY: float = 128.0
const REACTION_TIME: float = 0.25

# to set

@export_node_path("Node2D") var pigeon_path: NodePath

# external signals

signal hold_pressed
signal hold_released
signal hit_pressed
signal hit_released

# internal

var direction: Vector2 = Vector2.ZERO
var state: StringName = "idle"

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
						if state == "idle":
							hold_pressed.emit()
							state = "holding"
							pigeon_forearm.freeze = true
					else:
						if state == "holding":
							hold_released.emit()
							state = "idle"
							pigeon_forearm.freeze = false
				KEY_C:
					if event.pressed:
						if state == "idle":
							hit_pressed.emit()
							state = "hitting"
							$TimerHit.start()

func _physics_process(delta: float):
	if direction:
		var impulse: Vector2 = _get_velocity_control_impulse(direction, delta)
		match state:
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

func _on_timer_hit_timeout():
	state = "cooling"
	$TimerHitCooldown.start()

func _on_time_hit_cooldown_timeout():
	state = "idle"
