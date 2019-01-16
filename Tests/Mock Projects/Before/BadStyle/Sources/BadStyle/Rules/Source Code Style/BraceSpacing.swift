// Header

let x = [].map {$0} // These braces should trigger; They should be spaced.
func y() {} // These braces are fine; they are empty.
func z(){}// These braces should trigger; they should be spaced.
