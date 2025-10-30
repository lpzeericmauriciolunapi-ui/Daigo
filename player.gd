extends CharacterBody2D

@export var velocidad := 200.0
@export var cuadro_reposo := 0

@onready var animacion := $AnimatedSprite2D

var objeto_cercano: Node = null
var mirando_izquierda := false

func _physics_process(_delta):
	var entrada := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	velocity = entrada.normalized() * velocidad
	move_and_slide()

	if abs(entrada.x) > 0.01:
		animacion.flip_h = entrada.x > 0
		mirando_izquierda = animacion.flip_h
	else:
		animacion.flip_h = mirando_izquierda

	if entrada.length() > 0.01:
		if animacion.animation != "walk" or !animacion.is_playing():
			animacion.play("walk")
	else:
		if animacion.is_playing():
			animacion.stop()
		animacion.animation = "walk"
		animacion.frame = cuadro_reposo

func _input(evento):
	if evento.is_action_pressed("ui_accept") and objeto_cercano:
		objeto_cercano.interactuar()

func _on_InteractArea_body_entered(cuerpo):
	if cuerpo.has_method("interactuar"):
		objeto_cercano = cuerpo

func _on_InteractArea_body_exited(cuerpo):
	if objeto_cercano == cuerpo:
		objeto_cercano = null
