require "./Board.rb"
require "json"
class Game
    attr_accessor :board, :game_over, :turn, :coords, :from, :to

    def initialize(board = Board.new,turn = 0)
        @board = board
        @game_over = false
        @turn = turn


        new_or_load
        play_game(@turn)
    end


    def new_or_load
        puts "enter 'n' for new game or 'l' to load a saved game"
        answer = gets.chomp.downcase
        if answer == "n" 
            puts "Starting new Game"
        else
            puts "Loading Game"
            board = Board.new(load_game[0])
            turn = load_game[1]
            @board = board
            @turn = turn
        end
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

    def king_in_check?(player, king_coord,game_turn)
        if player == :white
            @board.black_pieces.any? do |piece, coord|
                legal_move?(coord,king_coord,game_turn)
            end
        else
            @board.white_pieces.any? do |piece, coord|
                legal_move?(coord,king_coord,game_turn)
            end
        end
    end

    def accept_move(player)
        accepted_move = false   
        until accepted_move
            @coords = self.get_move(player)
            @from = coords[0]
            @to = coords[1]
            next unless self.legal_move?(@from,@to,@turn)
            accepted_move = true
        end
    end

    def show_board(from,to,turn)
        self.board.update(from,to,turn)
            puts self.board.print_board
    end

    def play_game(turn)

        until @game_over
            puts self.board.print_board
            @turn += 1
            player = @turn.odd? ? :white : :black

            accept_move(player)
            show_board(@from,@to,@turn)

            #king in check?
            king_coord = @board.get_king(player)[1]
            if king_in_check?(player, king_coord,@turn)
                show_board(@to,@from,@turn)#reverts the board 
                puts "\nyour king is in check pay attention!\n".upcase
                accept_move(player)
                show_board(@from,@to,@turn)
            end
            
            #need a check for checkmate
            puts "the end next turn"

            if self.quit_game?
                self.save_game(turn)
                break
            end
        end
    
    end

    def save_game(turn)
        pieces = {}
        @board.board.each_pair do |coord, obj|
            next if obj.nil?
            features = [obj.class, obj.colour]
            if obj.is_a? Pawn
                features << (obj.turn_of_first_move)
            elsif (obj.is_a? Rook) || (obj.is_a? King)
                features << obj.never_moved
            end
            pieces[coord] = features
        end
        data = JSON.dump ({:board => pieces, :turn => turn})
        File.open('saved_game.json', 'w') {|file| file.write(data)}
    end

    def load_game
        data = JSON.load File.read('saved_game.json')
        turn = data['turn']
        pieces = data['board']

        board = {}
        ["a","b","c","d","e","f","g","h"].each do |letter|
            for rank in 1..8
                board[(letter + "#{rank}").to_sym] = nil
            end
        end

        pieces.each_pair do |coord, features|
            if features[2]
                board[coord.to_sym] = Object.const_get(features[0]).new(features[1].to_sym, features[2])
            else
                board[coord.to_sym] = Object.const_get(features[0]).new(features[1].to_sym)
            end
        end

        [board,turn]
    end

    def quit_game?
        puts "do you want to quit the game or continue?"
        puts "please enter 'q' or 'c'"
        answer = gets.chomp.downcase
        until answer == "q" || answer == "c"
            puts "please enter 'q' or 'c'"
            answer = gets.chomp.downcase
        end
        return answer == "q" ? true : false
    end
end


Game.new