Shoes.app :title=>"Prueba",
	:width=>1100, 
	:heigth=>1500,
 	:margin=>10,
 	:resizable => false do
 	
  	background "#02E488".."#220909"
	
	stack :width =>"100%" do
		@titulo = title "Detector de Tokens"
		@titulo.stroke = "#BF4646"
		@titulo.align = "center"
		@titulo.family = "Comic Sans"
	end

	stack :width=>"50%" do
		flow :width=>"100%" do

			@captionSeleccionarArchivo = caption(:top=>320, :left => 150)
			@captionSeleccionarArchivo.text = "Seleccionar Archivo"
			@captionSeleccionarArchivo.size = 12
			
			@captionPlay = caption(:top=>320, :left=>340)
			@captionPlay.text = "Ejecutar"
			@captionPlay.size = 10

			@imgSelect = image("seleccionar.png", :top=>140, :left =>170, :width=>100, :heigth=>100)
			@imgSelect.click do
				@filename = ask_open_file
				@captionPath.text = @filename
			end

			@imgPlay = image("play.png", :top=>140, :left => 320, :width => 100, :heigth=>100)
			@imgPlay.click do
				alert("Ejecutar")
			end

			@captionRuta = caption(:top=>170, :left=>60)
			@captionRuta.text = "Ruta: "
			
			@captionPath = caption(:top =>170, :left=>120)
			@captionPath.size = 13
			@captionPath.width = 400
		end
	end
end