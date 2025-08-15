extends Control
class_name ColorControl

@export var color_rect: ColorRect

@onready var red_slider: VSlider = $VSliderRed
@onready var green_slider: VSlider = $VSliderGreen
@onready var blue_slider: VSlider = $VSliderBlue
@onready var alpha_slider: VSlider = $VSliderAlpha
@onready var label: RichTextLabel = $VectorLabel

func _ready() -> void:
	var color_rect_material: Material = color_rect.material
	for slider in [red_slider, green_slider, blue_slider, alpha_slider]:
		slider.min_value = 0.0
		slider.max_value = 1.0
		slider.step = 0.01
	
	red_slider.value_changed.connect(func(v): _on_slider_changed(v, "r"))
	green_slider.value_changed.connect(func(v): _on_slider_changed(v, "g"))
	blue_slider.value_changed.connect(func(v): _on_slider_changed(v, "b"))
	alpha_slider.value_changed.connect(func(v): _on_slider_changed(v, "a"))
	
	if color_rect:
		var colors: Color = color_rect_material.get_shader_parameter("base_colors")
		red_slider.value = colors.r
		green_slider.value = colors.g
		blue_slider.value = colors.b
		alpha_slider.value = colors.a
		_update_text(colors)

func _update_text(color: Color):
	label.text = "vec4([color=red]%.2f[/color],  [color=green]%.2f[/color], [color=blue]%.2f[/color], [color=black]%.2f[/color]);"\
				% [color.r, color.g, color.b, color.a]

func _on_slider_changed(value: float, channel: String):
	var color_rect_material: Material = color_rect.material
	var color: Color = color_rect_material.get_shader_parameter("base_colors")
	match channel:
		"r": color.r = value
		"g": color.g = value
		"b": color.b = value
		"a": color.a = value
	color_rect_material.set_shader_parameter("base_colors", color)
	_update_text(color)
