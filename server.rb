require 'net/http'
require 'uri'

require 'botplayer.rb'
require 'client.rb'
require 'banker.rb'
require 'game.rb'
require 'socket'

#Returns the current time
def time
    Time.now.localtime.strftime("%d/%m/%Y %H:%M:%S")
end

#Checks whether 'request' is a valid HTTP request for jobfair/play 
def is_valid?(request)
    return false if request === nil
    parts = request.split(' ')
    if parts.size < 3 
        false
    elsif parts[0]=="GET" and parts[2].start_with? 'HTTP' and parts[1].scan("jobfair").size == 1 
        true
    else
        false
    end
end

#Returns a hash containing the GET arguments of the HTTP request 'request'
def get_args(request)
    path = request.split(' ')[1].split('?')
    if path.size != 2 then
        Hash.new
    else
        args = path[1].split('&')
        ret = Hash.new
        args.each do |str|
            arg = str.split('=')
            ret[arg[0].to_sym]=arg[1]
        end

        ret
    end
end

def action?(request)
    str = request.split(' ')[1].match(/jobfair\/([^?]+)\?.*/)
    if str == nil or str.size<2 then
        request.split('/').last
    else
        str[1]
    end
end

#TODO
def http_headers(status, fields)

end

#Runs a blocking HTTP server. Will yield (If given a block) for every valid request. 
def run_server(port = 80)
    server = TCPServer.new(80);
    puts "[#{time}] Server listening on port #{port}!"  

    loop do
        session = server.accept
        request = session.gets
        puts "[#{time}] Client connected: #{session.peeraddr[1]} #{session.peeraddr[2]}"; 
        puts "[#{time}] Request: #{request}"

        if is_valid?(request) then
            yield get_args(request), session, action?(request) if block_given?
        else
            session.print "HTTP/1.0 404 Not Found\r\nServer: KamibuJobfairPlayer\r\nContent-type: text/plain\r\n\r\n"
            puts "[#{time}] Request is invalid, returned 404!"
        end

        session.close
        puts "[#{time}] Connection closed!" 
    end
end

game = Game.new

run_server do |args, session, action|
    print "[#{time}] Request is valid, action #{action}, GET arguments: "
    args.each do |key, val|
        print "#{key} => #{val} " 
    end
    print "\n"

    if action=="start"
        body = game.start args
    elsif action=="ally"
        body = game.ally args
    elsif action=="play"
        body = game.play args
    else
        body = "Action does not exist!"
    end

    body += "\n"

    headers = "HTTP/1.1 200/OK\r\nServer: KamibuJobfairPlayer\r\nContent-Length: #{body.bytesize}\r\nTransfer-Encoding: utf8\r\nContent-type: text/plain\r\n\r\n"
    session.print headers + body

end

