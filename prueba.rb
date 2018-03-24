string = File.open("prueba.txt") #obtengo la el archivo 
cont=0 #contador que me va a servir para mi array
arreglo=Array.new(1) #declaro el array no importa el tamaño
while linea=string.gets #mientras tenga lineas el txt va a hacer lo siguiente
	arreglo[cont]=linea.chomp #guardo en el array la linea y le quito el salto de linea
	cont+=1 #incremento cont
end #termina el while
arreglo.each do |ar| #un each 
	cadena=ar #obtengo verifico si me guardo la cadena en el array
	cadena.each_byte do |c|	#este each_byte me sirve para ver que tanto tiene pero en ascii
		print "#{c} " #muestro el caracter en ascii 
	end
	print "\n"
end