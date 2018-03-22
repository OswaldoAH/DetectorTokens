Shoes.app :tittle => "Ventana" do
	class Actions
		@myApp
		def initialize(myApp)
			@myApp=myApp
		end
		def doLogin(username, password)
			@myApp.app do
				if (username=="Oswaldo" and password=="123")
					alert "bienvenido"
				else
					alert "incorrecto username/password"
			end
			
				
			end
		end
	end

	stack do
		@myActions=Actions.new(self)
		username=edit_line
		password=edit_line

		button "Login" do
			@myActions.doLogin(username.text, password.text)
		end
	end
end