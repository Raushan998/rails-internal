class LoggerMiddleware
    def initialize(app)
        @app = app
    end

    def call(env)
        puts "[LOG] #{env['REQUEST_METHOD']} #{env['PATH_INFO']}"
        status, headers, body = @app.call(env)
        puts "[LOG] status: #{status}"
        [status, headers, body]
    end
end