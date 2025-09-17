require 'socket'
require_relative 'router'
require_relative 'middleware'

server = TCPServer.new('localhost', 3000)
puts "Listening on http://localhost:3000"

app = LoggerMiddleware.new(Router.new)

loop do
    socket = server.accept

    Thread.new(socket) do |client|
        request_line = client.gets

        next unless request_line
        method, path, _ = request_line.split(" ")
        env = {method: method, path: path}
        status,headers, body = app.call(env)

        response = "HTTP/1.1 #{status} \r\n"
        headers.each {|k,v| response << "#{k}: #{v}\r\n"}
        response << "\r\n#{body}"
        client.print response
    rescue => e
        puts "Error: #{e.message}"
    ensure
        client.close
    end
end