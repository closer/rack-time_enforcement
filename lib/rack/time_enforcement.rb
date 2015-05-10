require "timecop"
require "time"

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
        if env['HTTP_TIME_ENFORCEMENT_AT']
          headers['Time-Enforcement-Enabled'] = 'false'
        end
      end


      headers['Time-Enforcement-Available'] = 'true'

      [code, headers, body]
    end

    def time_extract(env)
      if env['HTTP_TIME_ENFORCEMENT_AT']
        begin
          Time.parse env["HTTP_TIME_ENFORCEMENT_AT"]
        rescue
          nil
        end
      end
    end
  end
end
