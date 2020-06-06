extends Panel

onready var ocean : Ocean = $"../Ocean"

func _on_amplitude_changed(value: float) -> void:
	ocean.set_amplitude(value)

func _on_wavelength_changed(value: float) -> void:
	ocean.set_wavelength(value)

func _on_stepness_changed(value: float) -> void:
	ocean.set_steepness(value)

func _on_windX_changed(value: float) -> void:
	ocean.set_wind_directionX(value)

func _on_windY_changed(value: float) -> void:
	ocean.set_wind_directionY(value)

func _on_windalign_changed(value: float) -> void:
	ocean.set_wind_align(value)

func _on_speed_changed(value: float) -> void:
	ocean.set_speed(value)

func _on_noise_amp_changed(value: float) -> void:
	ocean.set_noise_amplitude(value)

func _on_noise_freq_changed(value: float) -> void:
	ocean.set_noise_frequency(value)

func _on_noise_speed_changed(value: float) -> void:
	ocean.set_noise_speed(value)
