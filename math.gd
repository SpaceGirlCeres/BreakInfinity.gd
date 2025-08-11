extends Node2D
var starting_num = 1e3

func rounded(num, decimal = 3) -> float: 
	return float(round(num * (10 ** decimal)) / ( 10 ** decimal))
	
func scientist(num: float) -> String:
	var exponent: int = floor(loger(num))
	var mantissa: float = rounded(num/(10**exponent))
	
	if num >= starting_num:
		return str(mantissa) + 'e' + str(exponent)
	else:
		return str(num)
	
func loger(num, base = 10) -> float: 
	return float(log(num)/log(base))
