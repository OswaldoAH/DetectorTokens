class Archivos
	attr_accessor :archivo
	def initialize(ruta)
		@archivo=File.open(ruta)
	end
	def archivo
		@archivo
	end
end

file=Archivos.new("prueba.txt") #instancio la clase
cont=0 #contador que me va a servir para mi array
arreglo=Array.new(1) #declaro el array no importa el tamaño

while linea=file.archivo.gets#mientras tenga lineas el txt va a hacer lo siguiente
	arreglo[cont]=linea.chomp #guardo en el array la linea y le quito el salto de linea
	cont+=1 #incremento cont
end#termina el while
arreglo.each do |ar| #un each 
	cadena=ar #obtengo verifico si me guardo la cadena en el array
	puts cadena
end
