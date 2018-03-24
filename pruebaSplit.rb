cadena = "Alvarez \n Hernandez, Mynor   Oswaldo" #String a separar
cadena2=cadena.split(/ /) #Metodo split que separa todo en subcadenas

cadena2.each_with_index do |cad, index| #each para mostrar el contenido del nuevo arreglo
	puts "#{index} contenido #{cad}"
	cadena1=cad
	if cadena1==''
		puts "error en la linea #{index}"
	end
end
