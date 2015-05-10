module Rack
  class TimeEnforcement
    class Railtie < Rails::Railtie
      initializer "time_enforcement.congigure_rails_initialization" do |app|
        app.middleware.use Rack::TimeEnforcement
      end
    end
  end
end
