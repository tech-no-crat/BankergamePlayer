#Client bot
class Client < BotPlayer

    def initialize
        super
    end

    def play(args, is_ally)
        puts "Client > Playing as client #{is_ally ? "with ally" : "" }!"
        if not arguments_ok?(args) then
            return "Some required arguments are missing!"
        end

        puts "Client > #{args[:youramount]} out of #{args[:totalamount]} offered!"
        if is_ally
            puts "Client > Accepting (ally)!"
            return "accept"
        elsif args[:youramount].to_i >= (args[:totalamount].to_i/2).floor then
            puts "Client > Accepting!"
            return "accept" 
        else
            puts "Client > Rejecting!"
            return "reject"
        end
    end
end
