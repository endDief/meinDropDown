require_relative "config/env"
require_relative "controller/controller"
require_relative "model/model"
require_relative "view/swing"

model = Model.new(api_key: ENV["API_KEY"])
view = Window.new
controller = Controller.new(model: model,view: view)
puts "API_KEY: #{ENV["API_KEY"].inspect}"
view
