extends Control
class_name LeaderboardMenu

@export var back_button : Button
@export var highscore_menu : Control

func on_leaderboard_hide() ->void:
    get_parent()._on_leaderboard_is_inactive()