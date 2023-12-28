Api::Engine.routes.draw do
  scope :distribution do
    get '/', to: 'distribution#index', as: :distribution
  end
end
