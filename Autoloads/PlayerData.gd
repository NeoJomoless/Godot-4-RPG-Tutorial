extends Node

var Player_Health = 4
var Player_Damage = 1

enum ClassChoice {
	Mage,
	Warrior,
	Thief
}

var Class = ClassChoice.Warrior

var Player_Level = 1
var Exp = 0
var Exp_Gained = 0
var Exp_Required = required_exp_func(Player_Level +1)

func required_exp_func(ply_lvl):
	return round(pow(ply_lvl, 1.5) + ply_lvl * 3)

func exp_gain(expgain):
	Exp += expgain
	if Exp < Exp_Required:
		Exp_Gained += expgain
		Exp_Required -= expgain
	elif Exp >= Exp_Required:
		lvl_up()

func lvl_up():
	Exp -= Exp_Gained
	Player_Level += 1
	Exp_Required = required_exp_func(Player_Level +1)
	increase_stats()

func increase_stats():
	Player_Health += 10
	Player_Damage += 1
