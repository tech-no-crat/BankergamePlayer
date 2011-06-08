#Banker bot
class Banker < BotPlayer

    def initialize
        super
    end

    def play(args, is_ally)
        puts "Banker > Playing as banker #{is_ally ? "with ally" : "" }!"
        if not arguments_ok?(args) then
            return "Some required arguments are missing!"
        end

        if is_ally
            offer = args[:totalamount].to_i
        elsif(args[:totalamount].to_i >= 2) then
            offer = (args[:totalamount].to_i/2).floor
        else
            offer = args[:totalamount].to_i
        end

        puts "Banker > Offering #{offer}!"
        offer
    end
end
