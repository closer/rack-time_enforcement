require "timecop"

module Rack
  class TimeEnforcement
    def initialize(app)
      @app = app
    end

    def call(env)
      if time = time_extract(env)
        code, headers, body = Timecop.travel(time) { @app.call(env) }
        headers['TimeEnforcement-Enabled'] = 'true'
      else
        code, headers, body = @app.call(env)
      end

      headers['TimeEnforcement-Available'] = 'true'

      [code, headers, body]
    end

    def time_extract(env)
      if env['TimeEnforcement-At']
        begin
          Time.parse env["TimeEnforcement-At"]
        rescue
          nil
        end
      end
    end
  end
end
