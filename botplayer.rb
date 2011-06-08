#Base class for both the client and banker bots
class BotPlayer
    def initialize()
        @id = nil;
    end
    
    #Checks whether the hash 'args' has all the necessary arguments to play
    def arguments_ok?(args)
        if args[:yourid]===nil or args[:opponentid]===nil or args[:totalamount]===nil or args[:yourwins]===nil or args[:opponentwins]===nil then
            return false
        end
        if self.class.name == "Client" and args[:youramount]===nil then
            return false
        end

        return true
    end
end

