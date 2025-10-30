extends CharacterBody2D

@export var velocidad := 200.0
@export var cuadro_reposo := 0

@onready var animacion: AnimatedSprite2D = $AnimatedSprite2D
@onready var area_interact: Area2D = $InteractArea
@onready var hint: Label = $"../UI/Label"  # El label para mostrar el mensaje

var objeto_cercano: Area2D = null
var mirando_izquierda := false

func _ready():
	print("Jugador listo. Esperando colisiones...")

# Movimiento del jugador
func _physics_process(_delta):
	var entrada := Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	)

	velocity = entrada.normalized() * velocidad
	move_and_slide()

	# Control de animaciones
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

	# Mostrar el texto de interacción si hay un objeto cercano
	if objeto_cercano != null:
		hint.text = "Presiona Enter para interactuar"
	else:
		hint.text = ""

# Detectar la entrada de un botón para interactuar
func _input(evento: InputEvent) -> void:
	if evento.is_action_pressed("ui_accept") and objeto_cercano:
		print("🟢 Intentando interactuar con:", objeto_cercano.name)
		if objeto_cercano.has_method("interactuar"):
			objeto_cercano.interactuar()

# Detectar cuando entra en rango de un objeto interactuable
func _on_interact_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("inter"):
		objeto_cercano = area
		print("➡ Tocando objeto interactuable:", area.name)

# Detectar cuando sale del rango del objeto interactuable
func _on_interact_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("inter"):
		print("⬅ Dejaste de tocar:", area.name)
		objeto_cercano = null
