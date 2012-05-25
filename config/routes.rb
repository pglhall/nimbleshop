class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Nimbleshop::Application.routes.draw do
  draw :admin
  draw :front_end
  draw :engines

  root :to => "products#index"
end
