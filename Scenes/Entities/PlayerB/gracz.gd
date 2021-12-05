extends RigidBody2D

export var vel = 100
var dlugoscNogi = 152
var kosci = []
var kostki = []
var gdzieWrog = Vector2()

func _ready():
	for i in range(8):
		kosci.append(get_node("Skeleton2D/Bone2D/" + String(i)))
		kostki.append(get_node("Skeleton2D/Bone2D/" + String(i) + "/" + String(i)))
	set_physics_process(true)

func _integrate_forces(state):
	if Input.is_action_pressed("move_left"):
		apply_central_impulse(Vector2(-vel,0))
	elif Input.is_action_pressed("move_right"):
		apply_central_impulse(Vector2(vel,0))
	elif Input.is_action_pressed("move_up"):
		apply_central_impulse(Vector2(0,-vel))
	elif Input.is_action_pressed("move_down"):
		apply_central_impulse(Vector2(0,vel))
	if Input.is_action_pressed("ui_select"):
		gdzieWrog = Vector2(0,0) #jak nie ma wroga to strzelamy w 0,0
		$Pajeczyna.points[1] = to_local(gdzieWrog)
	else:
		self.mass = 1
	for i in range(8):
		var poz = get_parent().get_node("noga" + String(i+1)).get_global_position()
		var odleglosc = self.global_position.distance_to(poz)
		if odleglosc >= dlugoscNogi:
			kosci[i].set_rotation(self.global_position.direction_to(poz).angle())
			kostki[i].set_rotation(0)
			kostki[i].set_scale(Vector2(kostki[i].get_global_position().distance_to(poz)/70, 1))
		else:
			var kat = asin(odleglosc/(2*dlugoscNogi))
			kosci[i].set_rotation(self.global_position.direction_to(poz).angle() - kat)
			kostki[i].set_rotation(kat*2)
			kostki[i].set_scale(Vector2(1, 1))

func _physics_process(_delta):
	pass

func _on_Area2D_body_exited(body):
	for i in range(8):
		if body.name == "noga" + String(i+1):
			body.get_node("CollisionShape2D").set_deferred("disabled", true)
			get_node("Area2D/Timer").start()
			yield(get_node("Area2D/Timer"), "timeout")
			body.get_node("CollisionShape2D").set_deferred("disabled", false)
			break
