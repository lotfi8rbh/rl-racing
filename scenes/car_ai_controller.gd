extends AIController3D
class_name CarAIController

var track: Track

var human_controlled_on_inference: bool


func reset():
	n_steps = 0
	needs_reset = false


func get_obs_for_car(car: Car):
	var player_velocity = car.get_normalized_velocity_in_player_reference()
	var observations: Array = [player_velocity.x, player_velocity.z, car.angular_velocity.y / 5.0]

	observations.append_array(car.get_next_track_points(3, 20))
	observations.append_array(car.raycast_sensor_wall.get_observation())
	observations.append_array(car.get_other_car_position_in_local_reference())

	return observations


func get_obs() -> Dictionary:
	_player.prepare_for_sending_obs()
	return {"obs": get_obs_for_car(_player)}


func get_reward() -> float:
	_player.update_reward()
	return reward


func get_action_space() -> Dictionary:
	return {
		"acceleration": {"size": 1, "action_type": "continuous"},
		"steering": {"size": 1, "action_type": "continuous"},
	}


## This override disables restarting the episode due to timeout
func _physics_process(_delta):
	n_steps += 1


func set_action(action) -> void:
	_player.requested_acceleration = clampf(action.acceleration[0], -1.0, 1.0)
	_player.requested_steering = clampf(action.steering[0], -1.0, 1.0)
