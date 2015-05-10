require "timecop"

module Rack
  class TimeEnforcement
    def initialize(app)
      @app = app
    end

    def call(env)
      if time = time_extract(env)
        code, headers, body = Timecop.travel(time) { @app.call(env) }
        headers['Time-Enforcement-In'] = time.to_s
        headers['Time-Enforcement-Enabled'] = 'true'
      else
        code, headers, body = @app.call(env)
      end

      headers['Time-Enforcement-Available'] = 'true'

      [code, headers, body]
    end

    def time_extract(env)
      if env['Time-Enforcement-At']
        begin
          Time.parse env["Time-Enforcement-At"]
        rescue
          nil
        end
      end
    end
  end
end
