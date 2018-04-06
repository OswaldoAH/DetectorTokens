
#clase para abrir el archivo.
#def initialize es el constructor
#def archivo devuelve la variable archivo
class DetectorTokens
	#Declaro los atributos de mi clase me sirven en otro metodos
	attr_accessor :archivo
	attr_accessor :palabraReservada
	attr_accessor :palabraReservadacont
	attr_accessor :operadores
	attr_accessor :operadorescont
	attr_accessor :signos
	attr_accessor :signoscont
	attr_accessor :cont
	attr_accessor :arreglo
	attr_accessor :variablesInt 
	attr_accessor :variablesIntCont
	attr_accessor :variablesFloat     
	attr_accessor :variablesFloatCont 
	attr_accessor :variablesBool      
	attr_accessor :variablesBoolCont  
	attr_accessor :variablesString    
	attr_accessor :variablesStringCont
	attr_accessor :erroresNoLinea
	attr_accessor :erroresLinea  

	def initialize
		@palabraReservada=["int","float","bool","string","if","else","while","do","true","false"]
		@palabraReservadacont=[0,0,0,0,0,0,0,0,0,0]
		@operadores=["+","-","*","/","%","=","==","<",">",">=","<="]
		@operadorescont=[0,0,0,0,0,0,0,0,0,0,0]
		@signos=["(",")","{","}","\"",";"]
		@signoscont=[0,0,0,0,0,0]
		@variablesIntCont=Array.new(1)
		@cont=0 #contador que me va a servir para mi array
		@arreglo=Array.new(1) #declaro el array no importa el tamaño
		@variablesInt=Array.new #Array donde se van a guardar las variables
		@variablesIntCont=Array.new
		@variablesFloat=Array.new
		@variablesFloatCont=Array.new
		@variablesBool=Array.new
		@variablesBoolCont=Array.new
		@variablesString=Array.new
		@variablesStringCont=Array.new
		@erroresNoLinea = Array.new
		@erroresLinea = Array.new
	end

	def pasarArray
		while linea=@archivo.gets#mientras tenga lineas el txt va a hacer lo siguiente
			@arreglo[@cont]=linea.chomp #guardo en el array la linea y le quito el salto de linea
			@arreglo[@cont].end_with?(';') ? @signoscont[5]+=1 : 0
			@cont+=1 #incremento cont
		end#termina el while
	end

	def rutaArchivo(ruta)
		@archivo=File.open(ruta)
		pasarArray
	end

	def CapturarErroresPR(cad,index)	#recibe como parametro una cadena, un vector y el indice donde puede ocurrir o no el error
		mayuscula=false
		for i in (65..90)
			cad.include?(i.chr) ? mayuscula=true : 0
		end
		if ((cad.length>1) && !(cad.eql?"return"))				#si el tamaño de la cadena que recibe es mayor a 1 hace lo siguiente
			k=0
			bandera=[true,true,false]
			while k<cad.length
				cadena1=cad[0,k+1]
				i=0
				if mayuscula
					erroresNoLinea << index+1
					erroresLinea << cad
				else
					while i<@palabraReservada.length&&bandera[1]
						j=0
						if cadena1.include?(@palabraReservada[i])
							if cad.length>@palabraReservada[i].length
								if !((cadena1.eql?"while") || (cadena1.eql?"if")||(cadena1.eql?"do"))
									if cadena1.eql?(@palabraReservada[i])
										erroresNoLinea << index+1
										erroresLinea << cad
										return true
									else
										cont=0
										if !cad.eql?"false"
											@palabraReservada[i].each_char { |c| cadena1.include?(c) ? cont+=1 :0 }
											if cont==@palabraReservada[i].length
												erroresNoLinea << index+1
												erroresLinea << cad
												return true
											end
										end
									end
								else
									cadena2=cad[cadena1.length,cad.length]
									if !(((cadena1.eql?"while") || (cadena1.eql?"if"))&&(cadena2[0].eql?"("))
										if !((cadena1.eql?"do")&&(cadena2[0].eql?"{"))
											erroresNoLinea << index+1
											erroresLinea << cad
											return true
										else
											bandera[1]=false
										end
									else
										bandera[1]=false
									end
								end
							else
								bandera[1]=false
							end
						else
							if (cadena1==cad) && !(cad.eql?"false")
								cont=0
								@palabraReservada[i].each_char { |c| cadena1.include?(c) ? cont+=1 :0 }
								if cont==@palabraReservada[i].length
									erroresNoLinea << index+1
									erroresLinea << cad
									return true
								end
							else
								cadena1=cadena1.squeeze
								bandera[0]=false
							end
						end
						if bandera[1] && bandera[0]
							bandera[0]=true
							while bandera[0]
								if cadena1.downcase.eql?(@palabraReservada[i])
									erroresNoLinea << index+1
									erroresLinea << cad
									bandera[0]=false
									return true
								elsif j==@palabraReservada.length
									bandera[0]=false
								end
								j+=1
							end
						end
						i+=1
					end
					k+=1
				end
			end
			return false
		end
	end

	def ContarVar(variable)
		bandera=false
		for i in (0..9)
			if variable[0].eql?(i.to_s)
				puts variable
				bandera=true
			end
		end
		for i in (0..signos.length-1)
			variable.include?(signos[i]) ? bandera=true: 0
		end
		for i in (0..operadores.length-1)
			variable.include?(operadores[i]) ? bandera=true : 0
		end
		if !bandera
			#Cuenta las variables de tipo int
			variablesInt.each_with_index do |var,index|
				var.eql?(variable) ? variablesIntCont[index]+=1 : 0
			end
			#Cuenta las variables de tipo float
			variablesFloat.each_with_index do |var,index|
				var.eql?(variable) ? variablesFloatCont[index]+=1 : 0
			end
			#Cuenta las variables de tipo bool
			variablesBool.each_with_index do |var,index|
				var.eql?(variable) ? variablesBoolCont[index]+=1 : 0
			end
			#Cuenta las variables de tipo string
			variablesString.each_with_index do |var,index|
				var.eql?(variable) ? variablesStringCont[index]+=1 : 0
			end
		end
		bandera
	end

	def CapturarErrorOp(cad,operador,index)
		cont=cad.index(operador)
		cad2=cad[(cont+1),cad.length]
		cont1=cad.index("(")
		if cont1.eql?(nil)
			cad1=cad[0,cont]
			if !cad2[0].eql?(nil)
				if ContarVar(cad1)
					erroresNoLinea<<index
					erroresLinea<<cad
				end
			end
		else 
			cad1=cad[(cont1+1),cad.length]
			cont1=cad1.index(operador)
			cad1=cad1[0,cont1]
			if !cad2[0].eql?(nil) 
				if ContarVar(cad1)
					erroresNoLinea<<index
					erroresLinea<<cad
				end
			end
		end
		cad=cad[(cont+1),cad.length]
		entero=cad.to_i

		if cad[0]=="=" || entero>0 || cad[0]=="0" || entero<0
			return true
		elsif cad[0]=="t" || cad[0]=="f" || cad[0]=="T" || cad[0]=="F"
			if cad.end_with?(";")
				cad=cad[0,cad.length-1]
				if !CapturarErroresPR(cad,index)
					cad.eql?("true") ? @palabraReservadacont[8]+=1 : @palabraReservadacont[9]+=1
					return true
				else
					return false
				end
			end
		elsif entero==0 && cad.length>0
			if cad[0].eql?("\"")
				return true
			elsif (operador==">"|| operador=="<")
				return !CapturarErroresPR(cad,index)
			end
		else

			return false
		end
	end

	def contarTokens(cad)
		i=0
		while i<cad.length
			cadena2=""
			cad.each_char do |c|
				cadena2+=c
				if cadena2.eql?(@palabraReservada[i])
					if cadena2.eql?("while")
						cont=cad.index("(")
						cad1=cad[(cont+1),cad.length]
						cad1[0].eql?("\!") ? cad1=cad1[1,cad1.length] : 0
						ContarVar(cad1)
					end
					@palabraReservadacont[i]+=1
				end
			end
			i+=1
		end
	end

	def BuscarVector(pr,variable)
		variable.end_with?(";") ? variable=variable[0,variable.length-1] : variable
		#puts variable
		case pr
		when "int"
			if variablesInt.length==0
				variablesInt[0]=variable
				variablesIntCont[0]=1
			else
				x=0
				encontrado=false
				variablesInt.each_with_index do |var,index| 
					if var.eql?(variable) 
						variablesIntCont[index]+=1 
						encontrado=true 
					else
						x=index
					end
				end
				if !encontrado
					variablesInt[x+1]=variable
					variablesIntCont[x+1]=1
				end
			end
		when "float"
			if variablesFloat.length==0
				variablesFloat[0]=variable
				variablesFloatCont[0]=1
			else
				x=0
				encontrado=false
				variablesFloat.each_with_index do |var,index| 
					if var.eql?(variable) 
						variablesFloatCont[index]+=1 
						encontrado=true 
					else
						x=index
					end
				end
				if !encontrado
					variablesFloat[x+1]=variable
					variablesFloatCont[x+1]=1
				end
			end
		when "bool"
			if variablesBool.length==0
				variablesBool[0]=variable
				variablesBoolCont[0]=1
			else
				x=0
				encontrado=false
				variablesBool.each_with_index do |var,index| 
					if var.eql?(variable) 
						variablesBoolCont[index]+=1 
						encontrado=true 
					else
						x=index
					end
				end
				if !encontrado
					variablesBool[x+1]=variable
					variablesBoolCont[x+1]=1
				end
			end
		when "string"
			if variablesString.length==0
				variablesString[0]=variable
				variablesStringCont[0]=1
			else
				x=0
				encontrado=false
				variablesString.each_with_index do |var,index| 
					if var.eql?(variable) 
						variablesStringCont[index]+=1 
						encontrado=true 
					else
						x=index
					end
				end
				if !encontrado
					variablesString[x+1]=variable
					variablesStringCont[x+1]=1
				end
			end
		end
	end

	def ContarVariables(array,index,pr) 
		#Recibe 3 parametros un vector, el indice de la linea en caso de errores, la palabra reservada ejmp int,float, etc
		#Comparar cada posición del array
		array.each do |var|
			#verifica las variables
			if !var.include?(pr) and !var.include?")"
				if var.count("=")==1
					CapturarErrorOp(var,"=",index)? @operadorescont[5]+=1 : 0
				end
				valor = var.split("=")
				valor.each do |val|
				x=0
					if val.include?("(") 
						x=val.index("(")
						val=val[x+1,val.length]
						CapturarErroresPR(val,index)
					end
				end
				BuscarVector(pr,valor[0])
				#si incluye un símbolo ( es porque es una función con parámetros
			elsif var.include?"("
				valor = var.split("(")
				valor.include?(pr) ? @palabraReservadacont[0]+=1 : 0
				BuscarVector(pr,valor[0])
				#si incluye un símbolo ) es porque es el parámetro de la función
			elsif var.include?")"
 				valor = var.split(")")
				BuscarVector(pr,valor[0])
			end
		end
	end

	def EjecutarDetector
		@arreglo.each_with_index do |array,index| #each para ir iterrar el vector que en este caso cada posicion del vector es una "linea del txt"
			array=array.split(/ /)			 #Sepraro cada linea si es que se puede en array detectando cada espacio
			cont=0
			array[0].eql?(nil) ? 0 : array[0]=array[0].strip
			if array[0].eql?("int")
			# 	#Comparación: el método main no lo tomará en cuenta, para eso sirve el unless
			 	unless array.include?"main"
			 		@palabraReservadacont[0]+=1
			 		ContarVariables(array,index,"int")
			 	else
			 		@palabraReservadacont[0]+=1
			 	end
			elsif array[0].eql?("float")
			 	@palabraReservadacont[1]+=1
			 	ContarVariables(array,index,"float")
			elsif array[0].eql?"bool"
			 	@palabraReservadacont[2]+=1
			 	ContarVariables(array,index,"bool")
			elsif array[0].eql?"string"
			 	@palabraReservadacont[3]+=1
			 	ContarVariables(array,index,"string")
			elsif array[0].eql?"return"
			 	cadena=array[1].delete(";")
			 	bandera=true
			 	for i in (0..9)
			 		if cadena[0].eql?(i.to_s) && cadena.length==1
			 			bandera=false
			 		end
			 	end
			 	if bandera
				 	if ContarVar(cadena) 
				 		erroresNoLinea<<index
						erroresLinea<<cadena
					end
			 	end
			elsif array[0].eql?"if"
			 	@palabraReservadacont[4]+=1
			elsif array.length!=1 && array.length!=0	##si el array su tamaño es diferente de 1 y de 0 hace lo siguiente
			 	array.each do |cad| #each para iterar el array
			 		cad=cad.strip     #le quito los tabuladores con ese metodo
			 		if ((cad.include?"=") && (cad.include?("\!")))
			 			if cad.count("=")==1 && cad.count("\!")==1
			 				if CapturarErrorOp(cad,"\!",index)
			 					@operadorescont[12]+=1
			 				else
			 					erroresNoLinea<<index
			 					erroresLinea<<cad
			 				end
			 			end
			 		elsif ((cad.include?"=") && (cad.include?("<")))
			 			if cad.count("=")==1 && cad.count("<")==1
			 				CapturarErrorOp(cad,"<",index) ? @operadorescont[10]+=1 : 0
			 			else
			 				erroresNoLinea<<index
			 				erroresLinea<<cad
			 			end
			 		elsif ((cad.include?"=") && (cad.include?(">")))
				 		if cad.count("=")==1 && cad.count(">")==1
				 			if CapturarErrorOp(cad,">",index)
			 					@operadorescont[9]+=1
			 				else
			 					erroresNoLinea<<index
			 					erroresLinea<<cad
			 				end
						else
							erroresNoLinea<<index
			 				erroresLinea<<cad
						end
					elsif cad.count("==")==2
						if CapturarErrorOp(cad,"=",index)
							@operadorescont[6]+=1
						else
							erroresNoLinea<<index
			 					erroresLinea<<cad
						end
					elsif cad.count("=")==1
						if CapturarErrorOp(cad,"=",index)
							@operadorescont[4]+=cad.count("%")
							@operadorescont[5]+=1
						else
							erroresNoLinea<<index
			 					erroresLinea<<cad
						end
					elsif cad.count(">")==1
						if CapturarErrorOp(cad,">",index)
							@operadorescont[8]+=1
						else
							erroresNoLinea<<index
			 				erroresLinea<<cad
			 			end
			 		elsif cad.count("<")==1
			 			if CapturarErrorOp(cad,"<",index)
			 				@operadorescont[7]+=1
			 			else
			 				erroresNoLinea<<index
		 					erroresLinea<<cad
		 				end
			 		end

					@signoscont[0]+=cad.count("(")					#estos métodos todos cuentan cuantos hay en cada linea
					@signoscont[1]+=cad.count(")")
					@signoscont[4]+=cad.count("\"")
					if cad.include?"{"
						@signoscont[2]+=1
					elsif cad.include?"}"
						@signoscont[3]+=1
					end
					if cad.end_with?('{') && cad.length>1
						cad=cad[0,cad.length-1]
					elsif cad[0]=="}" && cad.length>1
						cad=cad[1,cad.length]
					end
					if cad.eql?"else"
						@palabraReservadacont[5]+=1
					else
						CapturarErroresPR(cad,index) ? 0 : contarTokens(cad)
					end
					cad.eql?("do") ? @palabraReservadacont[7]+=1 : 0
					@operadorescont[0]+=cad.count("+")
					@operadorescont[1]+=cad.count("-")
					@operadorescont[2]+=cad.count("*")
					@operadorescont[3]+=cad.count("/")
			 	end
			elsif array.length==1 && array.length!=0					#de lo contrario si la cadena es 1 sola linea hago lo siguiente
				cad=array[0].strip 				#le vuelvo a quitar los tabuladores en este caso jalo del array =0 porque como es solo 1 vector
				bandera=true
				if bandera
					if ((cad.include?"=") && (cad.include?("<")))
						if cad.count("=")==1 && cad.count("<")==1
							if CapturarErrorOp(cad,"<",index)
								@operadorescont[10]+=1
							else
								erroresNoLinea<<index
			 					erroresLinea<<cad
								bandera=false
							end
						else
							erroresNoLinea<<index
		 					erroresLinea<<cad
							bandera=false
						end
					elsif ((cad.include?"=") && (cad.include?(">")))
						if cad.count("=")==1 && cad.count(">")==1
							if CapturarErrorOp(cad,">",index)
								@operadorescont[9]+=1
							else
								erroresNoLinea<<index
			 					erroresLinea<<cad
								bandera=false
							end
						else
							erroresNoLinea<<index
			 				erroresLinea<<cad
							bandera=false
						end
					elsif cad.count("==")==2
						if CapturarErrorOp(cad,"=",index)
							@operadorescont[6]+=1
						else
							erroresNoLinea<<index
			 				erroresLinea<<cad
							bandera=false
						end
					elsif cad.count("=")==1
						@operadorescont[4]+=cad.count("%")
						if CapturarErrorOp(cad,"=",index)
							@operadorescont[5]+=1
						else
							erroresNoLinea<<index
			 				erroresLinea<<cad
							bandera=false
						end
					elsif cad.count(">")==1
						CapturarErrorOp(cad,">",index) ? @operadorescont[8]+=1 : 0
					elsif cad.count("<")==1
						CapturarErrorOp(cad,"<",index) ? @operadorescont[7]+=1 : 0
					
					end
				end
				if !bandera
					CapturarErroresPR(cad,index)
				else
					@signoscont[0]+=cad.count("(")	#lo mismo cuento cuantos signos hay en esta linea
					@signoscont[1]+=cad.count(")")
					@signoscont[4]+=cad.count("\"")
					if cad.include?"{"
						@signoscont[2]+=1
					elsif cad.include?"}"
						@signoscont[3]+=1
					end
					if cad.end_with?('{') && cad.length>1
						cad=cad[0,cad.length-1]
					elsif cad[0]==("{") && cad.length>1
						cad=cad[1,cad.length]
					end
					cad.eql?("do") ? @palabraReservadacont[7]+=1 : 0
					contarTokens(cad)
					@operadorescont[0]+=cad.count("+")
					@operadorescont[1]+=cad.count("-")
					@operadorescont[2]+=cad.count("*")
					@operadorescont[3]+=cad.count("/")
				end
			end
		end
	end
end
#metodo creado por mi solo detecta los errores de palabras reservadas def CapturarErroresPR.
=begin
#La condicion me sirve para ver si la cadena que entra es mayor a 1 si es mayo a 1 hace lo siguiente
#k=0 y declaro un array de booleanos
#El primer while me sirve para comparar si la cadena incluye alguna de las palabreas reservadas y si la variable k es menor al tamaño de la cadena
#si cumple entra al primer while.
#obtengo una cadena concatenandole una letra cada paso del ciclo si se cumple con la condicion del while
## ejemplo cadena "while" primera vez dentro del ciclo cadena1="w" segunda vez en el ciclo cadena1="wh" y asi sucesivamente
#hago i=0 para verificar el siguiente while, si i es menor al tamaño del vector palabra reservada hace lo siguiente
#hago j=0
#si la cadena que esta en estos momentos en cadena1 incluye alguna de las palabras reservadas
#hace la segunda posicion del array de booleanos a falso
#termina la condicion
#en el elsif verifico si en la segunda posicion del bandera es verdadera si es verdadera eso queiere decir que
la cadena puede tener un error digo puede porque falta se compara completamente
#si no inlcuye hace un while donde la pimera posicion de bandera sea verdadera si es verdadera se hace la comparacion correspondiente
#si la cadena poniendolo todo en minuscula es igual a la alguna de las palabras reservadas
#######ejemplo
cadena1="wHile" con downcase cadena1="while" y comparandolo en el vector nos regresa true
candea1.downcase.eql?palabraReservada[i] es igual a decir
"while"=="while"=true
#si es verdadero capturamos el numero de la linea, el token con error y la linea completa donde esta el error
#ponemos la primera posicion de bandera en false para parar el ciclo y ponemos la 3ra posicion bandera verdadero
esto para decirle que si lo encontro
#si no es igual pero j= al tamaño de la palabra reservada
#hacemos la 3ra posicion falso que no lo ha encontrado y bandera en la 1ra posicion para salir
#aumentamos j
#al salir del 3er while pregunta si la bandera en la posicion 2 es falso es decir si no lo encontro va a seguir comparando
pero para esto necesitamos que la pimera bandera este en true
#si lo encontro seguíra haciendo el proceso pero ya no entrando al 3er while ya no compararia las cadenas
#aumentamos i par ael segundo while
#termina el segundo while
#aunmentamos k para el primer while
#termina el primer while
#termina la condicion
#termina el metodo
=end
# dtokens=DetectorTokens.new
# dtokens.rutaArchivo("Texto de prueba.txt")
# dtokens.EjecutarDetector
# for i in (0..dtokens.erroresLinea.length-1)
# 	puts "Error en la linea #{dtokens.erroresNoLinea[i]}\nLinea #{dtokens.erroresLinea[i]}"
# end
class Ventana
	attr_accessor :detector
	attr_accessor :filename
	def initialize
		@filename=""
	end

	def disenio
		Shoes.app :title=>"Detector de Tokens",
			:width=>1300, 
			:height=>520,
		 	:margin=>10,
		 	:resizable => false do
		 	@detector = DetectorTokens.new
		 	@values1 = Array.new(1)
		 	@x_axis1 = Array.new(1)
		  	background "#02E488".."#220909"
			#Área donde está el texto central
			stack :width =>"100%" do
				@titulo = title "Detector de Tokens"
				@titulo.stroke = "#BF4646"
				@titulo.align = "center"
				@titulo.family = "Comic Sans"
			end

			@arrayNuevo = Array.new
			#Caption para mostrar un texto debajo de una imagen
			@captionSeleccionarArchivo = caption(:top=>320, :left => 125)
			@captionSeleccionarArchivo.text = "Seleccionar Archivo"
			@captionSeleccionarArchivo.size = 12
			#Caption para mostrar un texto debajo de una imagen
			@captionPlay = caption(:top=>320, :left=>320)
			@captionPlay.text = "Ejecutar"
			@captionPlay.size = 10
			#Imagen para seleccionar el archivo al que se le van a encontrar los tokens
			@imgSelect = image("seleccionar.png", :top=>220, :left =>145, :width=>100, :height=>100)
			@imgSelect.click do
				@filename = ask_open_file
				@filename = @filename.gsub("\\", "/")
				@captionPath.text = @filename
				@detector.rutaArchivo(@filename)
			end
			#ComboBox
			@list = list_box :top=>70, :left =>500, :items => ["Palabras Reservadas", "Signos", "Operadores",
				"Variables Int", "Variables Float", "Variables bool", "Variables String"]
				#Botón mostrar gráfica
				boton = button "Mostrar Gráfica", :top=>130, :left =>515 do
					unless @captionPath.text.length.to_i.zero?
						if @list.text.length.zero?
							alert "Seleccione un valor en el Combo Box"
						elsif @list.text == "Palabras Reservadas"
							establecerGrafica(1)
						elsif @list.text == "Signos"
							establecerGrafica(2)
						elsif @list.text == "Operadores"
							establecerGrafica(3)
						elsif @list.text == "Variables Int"
							establecerGrafica(4)
						elsif @list.text == "Variables Float"
							establecerGrafica(5)
						elsif @list.text == "Variables bool"
							establecerGrafica(6)
						elsif @list.text == "Variables String"
							establecerGrafica(7)
						end
					else
						alert "Seleccione un archivo"
					end
				end
			#Imagen para ejecutar el detector de tokens
			@imgPlay = image("play.png", :top=>220, :left => 295, :width => 100, :height=>100)
			@imgPlay.click do
				@var = @captionPath.text.length
				#Condición para verificar si ya se seleccionó un archivo o no
				unless @var.to_i.zero?
					@detector.EjecutarDetector
					if @detector.erroresLinea.length.zero?
						alert "Tokens detectados correctamente"
					else
						alert "Error en la linea #{@detector.erroresLinea[0]}"
						boton.hide()
					end
				else
					alert("Seleccione un archivo")
				end
			end
			#Caption que se usa sólo para colocar un texto
			@captionRuta = caption(:top=>170, :left=>30)
			@captionRuta.text = "Ruta: "
			#Caption en el que se coloca la ruta del archivo seleccionado
			@captionPath = caption(:top =>173, :left=>80)
			@captionPath.size = 12
			@captionPath.width = 400
			@texto= edit_box :top=>70, :left =>750, :height=>400, :width=>500
	def establecerGrafica(valorGrafica)
		string=""
		if(valorGrafica == 1)
			for i in (0..@detector.palabraReservada.length-1)
				@values1[i]=@detector.palabraReservadacont[i]
				@x_axis1[i]=@detector.palabraReservada[i]
				string+="Se encontro #{@values1[i]} veces la palabra reservada #{@x_axis1[i]} \n"
			end
			alert string, :title => "Palabras Reservadas"
			grafica1(@values1, @x_axis1)
		elsif valorGrafica == 2
			for i in (0..@detector.signos.length-1)
				@values1[i]=@detector.signoscont[i]
				@x_axis1[i]=@detector.signos[i]
				string+="Se encontro #{@values1[i]} veces el signo #{@x_axis1[i]} \n"
			end
			alert string, :title => "Signos"
			grafica1(@values1, @x_axis1)
		elsif valorGrafica == 3
			for i in (0..@detector.operadores.length-1)
				@values1[i]=@detector.operadorescont[i]
				@x_axis1[i]=@detector.operadores[i]
				string+="Se encontro #{@values1[i]} veces el operador #{@x_axis1[i]} \n"
			end
			alert string, :title => "Operadores"
			grafica1(@values1, @x_axis1)
		elsif valorGrafica == 4
			for i in (0..@detector.variablesInt.length-1)
				@values1[i]=@detector.variablesIntCont[i]
				@x_axis1[i]=@detector.variablesInt[i]
				string+="Se encontro #{@values1[i]} veces el identificador #{@x_axis1[i]} \n"
			end
			alert string, :title => "Identificador INT"
			grafica1(@values1, @x_axis1)
		elsif valorGrafica == 5
			for i in (0..@detector.variablesFloat.length-1)
				@values1[i]=@detector.variablesFloatCont[i]
				@x_axis1[i]=@detector.variablesFloat[i]
				string+="Se encontro #{@values1[i]} veces el identificador #{@x_axis1[i]} \n"
			end
			alert string, :title => "Identificador FLOAT"
			grafica1(@values1, @x_axis1)
		elsif valorGrafica == 6
			for i in (0..@detector.variablesBool.length-1)
				@values1[i]=@detector.variablesBoolCont[i]
				@x_axis1[i]=@detector.variablesBool[i]
				string+="Se encontro #{@values1[i]} veces el identificador #{@x_axis1[i]} \n"
			end
			alert string, :title => "Identificador BOOL"
			grafica1(@values1, @x_axis1)
		elsif valorGrafica == 7
			for i in (0..@detector.variablesString.length-1)
				@values1[i]=@detector.variablesStringCont[i]
				@x_axis1[i]=@detector.variablesString[i]
				string+="Se encontro #{@values1[i]} veces el identificador #{@x_axis1[i]} \n"
			end
			alert string, :title => "Identificador STRING"
			grafica1(@values1, @x_axis1)
		end
		@values1 = Array.new
		@x_axis1 = Array.new
	end
	
	def grafica1(valores, eje)
		Shoes.app width: 500, height: 500 do
			widget_width = 500
			widget_height = 500
			@valorMax = 0
			if(valores.length > 1 and eje.length > 1)
				@arrayNuevo = valores.sort.reverse
				@valorMax = @arrayNuevo[0]+1;
			else
				@valorMax = valores[0]
			end
				@grf = plot widget_width, widget_height, title: "Gráfica", caption:
			"Amazing!!", font: "Mono", auto_grid: true,
			default: "skip", background: cornsilk, chart: "column", boundary_box: true
			
				@grf.add values: valores, labels: eje,
						name: "", min: 0, max: @valorMax, color: rgb(220, 20, 60, 172),
						points: true, strokewidth: 25
				end
			end


			def grafica2(valores, eje)
				Shoes.app width: 500, height: 500 do
					widget_width = 500
					widget_height = 500
					@valorMax = 0
					if(valores.length > 1 and eje.length > 1)
						@arrayNuevo = valores.sort.reverse
						@valorMax = @arrayNuevo[0]+1;
					else
						@valorMax = valores[0]
					end

					@grf = plot widget_width, widget_height, title: "Gráfica", caption:
					"Amazing!!", font: "Mono", auto_grid: true,
					default: "skip", background: cornsilk, chart: "pie", boundary_box: true
					
					@grf.add values: valores, labels: eje,
						name: "", min: 0, max: @valorMax, color: rgb(220, 20, 60, 172),
						points: true, strokewidth: 25
				end
			end
		end
	end
end

vent = Ventana.new
vent.disenio