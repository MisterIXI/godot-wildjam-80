class_name Highscore_Entry

var playername : String  =""
var time : String =""
var date : String =""
var collectables: String =""
var playeruid : String = ""
func _init(_playername,_time, _collectables, _date, _playeruid):
    playername = _playername
    time = _time
    date = _date
    collectables = _collectables
    playeruid = _playeruid