require "./Board.rb"
class Game
    attr_accessor :board
    def initialize
        @board = Board.new
        @game_over = false
        
    end

    def valid_coord?(coord)
        return false if coord.length != 2
        return false unless ["a","b","c","d","e","f","g","h"].include?(coord[0])
        return false unless ["1","2","3","4","5","6","7","8"].include?(coord[1])
        return true
    end

    def valid_and_occupied?(coord)
        return false unless valid_coord?(coord)
        return false unless @board.coord_occupied?(coord)
        return true
    end

    def right_coloured_piece?(player,coord)
        return @board.board[coord].colour == player ? true : false
    end

    def get_move(player)
        puts "please enter the square you would like to move from."
        from = gets.chomp.to_sym
        until (valid_and_occupied?(from) && right_coloured_piece?(player,from))
            puts "It has to be occupied and the right colour. Please try again."
            from = gets.chomp.to_sym
        end
        puts "Please enter the square you would like to move to."
        to = gets.chomp.to_sym
        until valid_coord?(to)
            puts "Please enter a valid square."
            to = gets.chomp.to_sym
        end
        return [from,to]      
    end

    def free_way?(from,to)
        cur_piece = @board.get_coord(from)
        if !(cur_piece.is_a? Knight)
            return false unless @board.clear_path?(from,to)
        end
        true
    end

    def valid_move?(from, to, game_turn)
        from_piece = @board.get_coord(from)
        if @board.get_coord(to).nil?
            if from_piece.is_a? Pawn
                
               
                return false unless from_piece.can_move?(from, to) || @board.en_passant?(from, to, game_turn)

            elsif from_piece.is_a? King

                return false unless @board.can_castle?(from,to) || from_piece.can_move?(from, to)
                
            else
                return false unless from_piece.can_move?(from, to)
                
            end

        else
            return false if from_piece.colour == @board.get_coord(to).colour

            if from_piece.is_a? Pawn
                reutrn false unless from_piece.can_attack?(from, to)
            else
                return false unless from_piece.can_move?(from, to)
            end

        end
        true
    end

    def legal_move?(from,to,game_turn)
        free_way?(from,to) && valid_move?(from,to,game_turn)
    end
end

#the part of the code that actually runs the game
def play_game

    chess = Game.new
    puts chess.board.print_board
    turn = 0

    until @game_over
        turn += 1
        player = turn.odd? ? :white : :black
        accepted_move = false
        
        until accepted_move
            coords = chess.get_move(player)
            from = coords[0]
            to = coords[1]
            next unless chess.legal_move?(from,to,turn) 
            #need a check for if the player's king is checked
            accepted_move = true
        end

        chess.board.update(from,to,turn)
        puts chess.board.print_board
        #need a check for checkmate
        #need a check for if opponent is checked
        puts "the end next turn"
    end

end


play_game
