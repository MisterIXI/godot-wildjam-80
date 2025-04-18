extends Line2D

func _ready() -> void:
    Session.golden_paper_enabled.connect(_change_shader_color_tint)

    if Session.golden_paper:
        _change_shader_color_tint()

func _change_shader_color_tint() ->void:
    material.set("shader_parameter/color_tint",Vector4(1.4,1.05,0.8,1));
    material.set("shader_parameter/line_color",Vector4(1.4,1.05,0.8,1));
