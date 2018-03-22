Shoes.app(:title => "Boton con selector de archivo") do
	a
    button "Abrir Archivo" do
        filename = ask_open_file
        a= File.read(filename)
        
    end
    para a
    
end