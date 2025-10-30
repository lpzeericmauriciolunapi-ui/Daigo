extends CharacterBody2D

@export var velocidad := 200.0
@export var cuadro_reposo := 0

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_interact: Area2D = $InteractArea

var objeto_cercano: Node = null
var mirando_izquierda := false

func _ready():
	print("Jugador listo. Esperando colisiones...")
	print("Área de interacción:", area_interact)

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

func _input(evento: InputEvent) -> void:
	if evento.is_action_pressed("ui_accept") and objeto_cercano:
		print("🟢 Intentando interactuar con:", objeto_cercano.name)
		objeto_cercano.interactuar()

func _on_InteractArea_body_entered(cuerpo: Node) -> void:
	var objetivo: Node = cuerpo
	var padre: Node = cuerpo.get_parent()

	if not objetivo.has_method("interactuar") and padre != null and padre.has_method("interactuar"):
		objetivo = padre

	if objetivo.has_method("interactuar"):
		objeto_cercano = objetivo
		print("➡ Tocando objeto interactuable:", objetivo.name)
	else:
		print("⚠ Entró en contacto con algo sin método interactuar:", cuerpo.name)

func _on_InteractArea_body_exited(cuerpo: Node) -> void:
	var objetivo: Node = cuerpo
	var padre: Node = cuerpo.get_parent()
	var nombre_objeto := ""

	if padre != null and objeto_cercano == padre:
		nombre_objeto = padre.name
	elif objeto_cercano == objetivo:
		nombre_objeto = objetivo.name

	if nombre_objeto != "":
		print("⬅ Dejaste de tocar:", nombre_objeto)
		objeto_cercano = null
