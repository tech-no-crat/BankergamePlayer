require 'net/http'
require 'uri'

class Player
    @@next_id = 1
    attr_accessor :id
    attr_accessor :money

    def initialize(url)
        @id = @@next_id
        @location = url
        @@next_id += 1
        @money = 0

        @id
    end

    def play_banker(amount = 100, opponentid = 0, opponentmoney = 0)
        url = @location + "?type=banker&yourid=#{@id}&opponentid=#{opponentid}&totalamount=#{amount}&yourwins=#{@money}&opponentwins=#{opponentmoney}"
        puts "[Player #{@id}] Playing as banker!"
        puts "[Player #{@id}] URL: #{url}"
        reply = Net::HTTP.get URI.parse(url)
        puts "[Player #{@id}] Reply: #{reply}"
        
        reply.to_i
    end
end

player1 = Player.new("http://localhost/jobfair/play")
player2 = Player.new("url")

p1 = player1.play_banker(100, player2.id, player2.money)
