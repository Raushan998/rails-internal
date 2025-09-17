require_relative 'path'
class Router
    def initialize
        @path = Path.new
    end

    def call(env)
        method = env[:method]

        case 
        when method == 'GET'
            @path.get_call(env)
        else
            [404, {'Content-Type'=>'text/plain'}, 'Not Found']
        end
    end
end