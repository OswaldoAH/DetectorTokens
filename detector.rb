Shoes.app :title=>"Prueba",
	:width=>1100, 
	:height=>500,
 	:margin=>10,
 	:resizable => false do
 	
  	background "#02E488".."#220909"
	
	#Área donde está el texto central
	stack :width =>"100%" do
		@titulo = title "Detector de Tokens"
		@titulo.stroke = "#BF4646"
		@titulo.align = "center"
		@titulo.family = "Comic Sans"
	end

	#Divido la pantalla a la mitad
	stack :width=>"50%" do
		#Uso el 100% de la mitad que partí
		flow :width=>"100%" do

			#Caption para mostrar un texto debajo de una imagen
			@captionSeleccionarArchivo = caption(:top=>320, :left => 150)
			@captionSeleccionarArchivo.text = "Seleccionar Archivo"
			@captionSeleccionarArchivo.size = 12
			
			#Caption para mostrar un texto debajo de una imagen
			@captionPlay = caption(:top=>320, :left=>340)
			@captionPlay.text = "Ejecutar"
			@captionPlay.size = 10

			#Imagen para seleccionar el archivo al que se le van a encontrar los tokens
			@imgSelect = image("seleccionar.png", :top=>140, :left =>170, :width=>100, :height=>100)
			@imgSelect.click do
				@filename = ask_open_file
				a = File.read(@filename)
				@captionPath.text = @filename
				#Por ahora se muestra en el edit_box lo que está en el archivo, pero es solo de prueba. En ese cuadro se van a mostrar
				#los errores que tenga el txt o los tokens que se hallan encontrado
				@editB.text = a
			end

			#Imagen para ejecutar el detector de tokens
			@imgPlay = image("play.png", :top=>140, :left => 320, :width => 100, :height=>100)
			@imgPlay.click do
				@var = @captionPath.text.length
				#Condición para verificar si ya se seleccionó un archivo o no
				unless @var.to_i.zero? 
					alert("Siga adelante") #Acá iría la llamada a la función CapturarErroresPR
				else
					alert("Seleccione un archivo")
				end
			end

			#Caption que se usa sólo para colocar un texto
			@captionRuta = caption(:top=>170, :left=>60)
			@captionRuta.text = "Ruta: "
			
			#Caption en el que se coloca la ruta del archivo seleccionado
			@captionPath = caption(:top =>170, :left=>120)
			@captionPath.size = 13
			@captionPath.width = 400
		end
	end

	#Se usa la otra mitad de la pantalla que se dividió arriba
	stack :width=>"50%" do
		#Acá aparecerán los tokens encontrados o los errores que tenga el archivo
		@editB = edit_box(:top=>10, :left=>10, :width=>500, :height=>400)
	end
end