extends RigidBody3D
class_name Car

var track: Track
var other_car: Car

# Car performance settings
var acceleration = 15.0
var torque = 7.0
var backward_acceleration_ratio = 0.75

@onready var ai_controller: CarAIController = %AIController
@onready var raycast_sensor_wall: RayCastSensor3D = %Raycasts
@onready var camera: Camera3D = $"Camera3D"

## Set by AIController during inference
var requested_acceleration: float
## Set by AIController during inference
var requested_steering: float

# Track related data
var track_length: float
var previous_offset: float
var next_checkpoint_offset: float
var current_offset: float
var laps_passed: int
var first_checkpoint_offset: float


# Game settings data
var infinite_race: bool
var total_laps: int
var seconds_until_race_begins: int
var training_mode: bool

var initial_transform: Transform3D
var _just_reset: bool


func _ready():
	ai_controller.init(self)
	initial_transform = global_transform
	track_length = track.track_path.curve.get_baked_length()
	first_checkpoint_offset = track_length / 30.0
	
	%Area3D.body_entered.connect(func(b):
		#ai_controller.reward -= 50.0
		reset()
	)


func reset():
	laps_passed = 0
	next_checkpoint_offset = first_checkpoint_offset

	global_transform = initial_transform
	
	if not training_mode:		
		process_mode = Node.PROCESS_MODE_DISABLED
		await get_tree().create_timer(seconds_until_race_begins, true, true).timeout
		process_mode = Node.PROCESS_MODE_INHERIT

	_just_reset = true

func _integrate_forces(state):
	if _just_reset:
		state.linear_velocity = Vector3.ZERO
		state.angular_velocity = Vector3.ZERO
		state.transform = initial_transform
		_just_reset = false


func get_next_checkpoint_offset() -> float:
	return fmod(next_checkpoint_offset + track_length / 30.0, track_length)


func get_other_car_position_in_local_reference() -> Array[float]:
	var local_position = (
		to_local(global_position - other_car.global_position).limit_length(150.0) / 150.0
	)
	return [local_position.x, local_position.z]


func _physics_process(_delta):
	if ai_controller.needs_reset:
		ai_controller.reset()
		reset()
	
	var acceleration_to_apply := 0.0
	var steering_to_apply := 0.0

	if ai_controller.heuristic == "human":
		update_track_related_data()

		if Input.is_action_pressed("move_forward"):
			acceleration_to_apply += acceleration
		if Input.is_action_pressed("move_backward"):
			acceleration_to_apply -= acceleration * backward_acceleration_ratio

		if Input.is_action_pressed("steer_left"):
			steering_to_apply += torque
		if Input.is_action_pressed("steer_right"):
			steering_to_apply -= torque
	else:
		if requested_acceleration < 0:
			requested_acceleration *= backward_acceleration_ratio
		acceleration_to_apply = requested_acceleration * acceleration
		steering_to_apply = requested_steering * torque

	apply_central_force(global_transform.basis.z * acceleration_to_apply)
	apply_torque(global_transform.basis.y * steering_to_apply)
	


## Updates any data needed before the AI controller sends observations
func prepare_for_sending_obs():
	update_track_related_data()


## Update the data for tracking the current progress along the track
func update_track_related_data():
	update_current_offset()
	update_checkpoint()


func update_current_offset():
	current_offset = track.track_path.curve.get_closest_offset(global_position)


func update_checkpoint():
	if abs(current_offset - next_checkpoint_offset) < (track_length / 60.0):
		next_checkpoint_offset = get_next_checkpoint_offset()
		if is_equal_approx(next_checkpoint_offset, track_length / 30.0):
			laps_passed += 1
			if infinite_race:
				_end_episode()


func update_reward():
	var offset_difference = current_offset - previous_offset

	if offset_difference > (track_length / 2.0):
		offset_difference = offset_difference - track_length

	if offset_difference < -(track_length / 2.0):
		offset_difference = offset_difference + track_length

	## Reward for moving along the track (positive or negative depending on direction)
	ai_controller.reward += offset_difference / 10.0

	## Backward movement penalty
	ai_controller.reward += min(0.0, get_normalized_velocity_in_player_reference().z + 0.1) * 5.0

	previous_offset = current_offset
	pass


func get_next_track_points(num_points: int, step_size: float) -> Array:
	var temp_array: Array[float] = []
	var closest_offset = current_offset

	for i in range(0, num_points):
		var current_point = track.track_path.curve.sample_baked(
			fmod(closest_offset + step_size * (i + 1), track_length)
		)
		var local = to_local(current_point) / (num_points * step_size)
		temp_array.append_array([local.x, local.z])
	return temp_array


func _end_episode(final_reward: float = 0.0):
	ai_controller.reward += final_reward
	ai_controller.done = true
	ai_controller.reset()

	if not infinite_race:
		reset()


func get_normalized_velocity_in_player_reference():
	return (global_transform.basis.inverse() * linear_velocity).limit_length(42.0) / 42.0


func _on_body_entered(_body):
	ai_controller.reward -= 4.0
