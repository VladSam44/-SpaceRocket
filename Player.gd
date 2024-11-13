extends RigidBody3D

#forta verticala aplicata
@export_range(750.0, 3000.0) var thrust: float = 1000.0
@export var torque_thrust: float = 100.0
var is_transitioning:bool = false 

@onready var finish: AudioStreamPlayer = $Finish
@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var rocket: AudioStreamPlayer3D = $Rocket
@onready var mijloc_particole: GPUParticles3D = $MijlocParticole
@onready var dreapta_particule: GPUParticles3D = $DreaptaParticule
@onready var stanga: GPUParticles3D = $Stanga
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		mijloc_particole.emitting = true
		if rocket.playing == false:
			rocket.play()
	else:
		mijloc_particole.emitting = false
		rocket.stop()
		  
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		dreapta_particule.emitting = true
	else:
		dreapta_particule.emitting = false
		
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
		stanga.emitting = true
	else:
		stanga.emitting = false
	


func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		if "Goal" in body.get_groups():
			complete_level(body.file_path)

		if "Hazard" in body.get_groups():
			cras_sequence()

func cras_sequence() -> void:
	print("EXPLOZIE!")
	explosion_particles.emitting = true
	explosion_audio.play()
	set_process(false)
	is_transitioning = true 
	var tween = create_tween()
	tween.tween_interval(3.0)
	tween.tween_callback(get_tree().reload_current_scene)

func complete_level(next_level_file: String) -> void:
	print("Nivel Completat")
	success_particles.emitting = true	
	finish.play()
	set_process(false)
	is_transitioning = true 
	var tween = create_tween()
	tween.tween_interval(5.0)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)
