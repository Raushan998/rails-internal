class ApplicationController
    def initialize(env)
        @env = env
    end

    def render(text, status: 200, content_type: "text/plain")
        [status, { "Content-Type" => content_type}, text]
    end
end