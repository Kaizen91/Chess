require "./Board.rb"
class Game
    attr_accessor :board
    def initialize
        @board = Board.new
        
    end

    def valid_coord?(coord)
        
    end

    def valid_and_occupied?(coord)
        
    end

    def right_coloured_piece?(coord)

    end

    def get_move
        puts "please enter the square you would like to move from."
        from = gets.chomp.to_sym
        until valid_and_occupied?(from) && right_coloured_piece?(from)
            puts "It has to be occupied and the right colour. Please try again."
            from = gets.chomp.to_sym
        end
        puts "Please enter the square you would like to move to."
        to = gets.chomp.to_sym
        until vaild_coord?(to)
            puts "Please enter a valid square."
            to = gets.chomp.to_sym
        end
        return [from,to]      
    end
end