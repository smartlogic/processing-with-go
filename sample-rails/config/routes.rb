Sample::Application.routes.draw do
  mount Resque::Server.new, :at => "/"
end
