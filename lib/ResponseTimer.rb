class ResponseTimer
  def initialize(app)
    @app = app
  end

  def call(env)
    start_time = Time.now
    status, headers, response = @app.call(env)
    end_time = Time.now
    time_to_render = end_time - start_time
    time_to_render_in_milliseconds = (time_to_render * 1000.0).round(2)
    headers["x-responded-in"] = time_to_render_in_milliseconds
    [status, headers, response]
  end
end