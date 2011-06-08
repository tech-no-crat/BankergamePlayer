class Game
    def initialize
        @client = Client.new
        @banker = Banker.new
        @ally_contacted = true
        @ally_id = nil
        @id = nil
        @game_started = false
    end

    def start(args)
        if not args.has_key?(:yourid)
            puts "Game > WARNING: Action start called without id argument, IGNORING id!"
            return "Argument 'yourid' missing!"
        end

        if @id != nil then
            puts "Game > WARNING: Action start called with id  #{args[:yourid]}, but id has already been set to #{@id}! Updating ID!"  
        end
        @id = args[:yourid]

        puts "Game > Starting game and contacting ally, id = #{@id}"
        contact_ally
        @game_started = true

        "OK"
    end

    def ally(args)
        if not args.has_key?(:id)
            puts "Game > Action ally called without id argument! Ignoring request!"
            return "Argument id missing!"
        end

        puts "Game > WARNING: Action ally called with id #{args[:id]}, but ally_id is already set to #{@ally_id}! Resetting to new allyid! " if @ally_id != nil

        @ally_id = args[:id]
        puts "Game > Action ally called, ally_id is #{@ally_id}!"

        "OK"
    end

    def play(args)
        is_ally = false
        is_ally = true if args[:opponentid]==@ally_id
        puts "Game > Playing with #{args[:opponentid]}!"
        
        if args[:type]=="client" then
            @client.play(args, is_ally).to_s
        elsif args[:type]=="banker"
            @banker.play(args, is_ally).to_s
        else
            puts "Game > HTTP GET argument 'type' missing!"
            "HTTP GET argument 'type' missing!"
        end
    end

    def contact_ally
        begin

            ally_url = "http://ted.kamibu.com/jobfair/ally?id=#{@id}"
            uri = URI(ally_url)
            http = Net::HTTP.new(uri.host, uri.port)
            path = uri.path.empty? ? "/" : uri.path
            puts "#{uri.path}?#{uri.query}"
            #test to ensure that the request will be valid - first get the head
            code = http.head(path).code.to_i
            if (code >= 200 && code < 300) then
                #the data is available...
                http.get("uri.path") do |chunk|
                    #provided the data is good, print it...
                    puts "Game > Ally at '#{ally_url}' contacted successfuly, reply: #{chunk}" unless chunk =~ />416.+Range/
                end
            else
                puts "Game > Ally at '#{ally_url}' returned bad HTTP status code!"
            end

        rescue SocketError, ArgumentError  => e
            puts "Game > WARNING: Got error while attempting to contant ally at '#{ally_url}': #{e} !"
        end

        @ally_contacted = true
    end
end
