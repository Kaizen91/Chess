require "./Pieces.rb"
class Board

attr_accessor :board, :turn
    def initialize(board = create_board)
        @turn = :white
        @board = board
    end

    def get_coord(coord)
        @board[coord]
    end

    def coord_occupied?(coord)
        return @board[coord].nil? ? false : true
    end

    def create_board
        board = {}
        ["a","b","c","d","e","f","g","h"].each do |col|
            for row in 3..6 do 
                board[(col+row.to_s).to_sym] = nil
            end
            board[(col+"2").to_sym] = Pawn.new(:white)
            board[(col+"7").to_sym] = Pawn.new(:black)
        end
        board[:a1] = Rook.new(:white)
        board[:h1] = Rook.new(:white)
        board[:a8] = Rook.new(:black)
        board[:h8] = Rook.new(:black)
        board[:b1] = Knight.new(:white)
        board[:g1] = Knight.new(:white)
        board[:b8] = Knight.new(:black)
        board[:g8] = Knight.new(:black)
        board[:c1] = Bishop.new(:white)
        board[:f1] = Bishop.new(:white)
        board[:c8] = Bishop.new(:black)
        board[:f8] = Bishop.new(:black)
        board[:e1] = King.new(:white)
        board[:e8] = King.new(:black)
        board[:d1] = Queen.new(:white)
        board[:d8] = Queen.new(:black)
        return board
    end

   def update(cur_coord,new_coord, game_turn)

    cur_piece = @board[cur_coord]

    #en_passant
    if (cur_piece.is_a? Pawn) && (en_passant?(cur_coord,new_coord,game_turn))
        opp_coord = ep_opp_coord(cur_coord,new_coord)
        @board[opp_coord] = nil
    end


    #pawn promotion

    #castling
    if (cur_piece.is_a? King) && can_castle?(cur_coord,new_coord)
        update_rook_after_castle(new_coord)
    end

    #actualmove
    move_piece(cur_coord,new_coord)

    #notes the turn when a pawn takes double squares on it's first move
    cur_piece.turn_of_first_move = game_turn if (cur_piece.is_a? Pawn) && (cur_coord[0] == new_coord[0]) && ((cur_coord[1].to_i - new_coord[1].to_i).abs == 2) 

    @board
   end

    def move_piece(cur_coord,new_coord)
        @board[new_coord] = @board[cur_coord]
        @board[cur_coord]= nil
    end

    def print_piece(coord)
        @board[coord].nil? ? " " : @board[coord].symbol
    end

    def print_board

        horizantal_coordinates = "   " +["a","b","c","d","e","f","g","h"].join("   ")

        topline = ("  ,"+ "----" * 8 + ",")

        basic_lines = (["|." * 8 +"|"] * 8)
        basic_lines = basic_lines.map.with_index do |line, ord|
            "#{8-ord} " + line + " #{8-ord}"
        end
        basic_lines = basic_lines.map do |line|
            line_no = line[0].to_i
            for i in 0...4
                coord1 = ((97 + i *2).chr + "#{line_no}").to_sym
                coord2 = ((97 + (i *2 + 1)).chr + "#{line_no}").to_sym
                if line_no.even?
                    line = line.sub ".", " #{print_piece(coord1)} \e[0m" #puts a white background and gets the piece representation\e[47m
                    line = line.sub ".", "\e[40m #{print_piece(coord2)} \e[0m" #puts a black background and gets the piece representation
                else
                    line = line.sub ".", "\e[40m #{print_piece(coord1)} \e[0m" #puts a black background and gets the piece representation
                    line = line.sub ".", " #{print_piece(coord2)} \e[0m" #puts a white background and gets the piece representation\e[47m
                end
            end
            line
        end

        middle_line  = ("  "+ "┣━━━" * 8 + "┫")
        bottom_line  = ("  " + "````" * 8 + "  ")

        body= basic_lines.join("\n" + middle_line + "\n")
        
        visualized_board = [horizantal_coordinates, topline, body, bottom_line, horizantal_coordinates].join("\n")
    end

    def clear_path?(from, to)
        path = path_between(from, to)
        return false if path.length == 0 
        path = path.flatten
        return true if path.length == 0 
        path.each do |coord|
            return false if @board[coord] 
        end
        true   
    end

    def path_between(from, to)
        from_letter_ord = from[0].ord
        from_num = from[1].to_i
        to_letter_ord = to[0].ord
        to_num = to[1].to_i
        difference = to_num - from_num

        path = [horizantal_check(from,to),
                vertical_check(from, to),
                forward_diagonal_check(from_letter_ord,from_num,to_letter_ord,to_num,difference),
                backward_diagonal_check(from_letter_ord,from_num,to_letter_ord,to_num,difference)]

        return path.compact
    end

    def vertical_check(from, to)
        return nil if from[0] != to[0]
        path = []
        return path if ((to[1].to_i)- (from[1].to_i)).abs == 1

        letter = from[0]
        min, max = 0, 0

        if to[1].to_i > from[1].to_i 
            min, max = ((from[1].to_i)+1), (to[1].to_i)
        else
            min, max = ((to[1].to_i)+1), (from[1].to_i)
        end

        for i in min...max
            path << (letter + i.to_s).to_sym
        end

        return path
    end

    def forward_diagonal_check(from_letter_ord,from_num, to_letter_ord, to_num, difference)
        return nil if (from_letter_ord - to_letter_ord) != (from_num - to_num)
        path =[]
        return path if difference.abs == 1

        if difference > 0 
            for i in 1...difference
                path << ((from_letter_ord +i).chr + (from_num + i).to_s).to_sym
            end
        else
            for i in 1 ...(difference.abs)
                path << ((from_letter_ord - i).chr + (from_num - i).to_s).to_sym
            end
        end

    end

    def backward_diagonal_check(from_letter_ord,from_num, to_letter_ord, to_num, difference)
        return nil if (from_letter_ord - to_letter_ord) != (to_num - from_num)
        path = []
        return path if difference.abs == 1

        if difference > 0
            for i in 1...difference
                path << ((from_letter_ord - i).chr + (from_num + i).to_s).to_sym
            end
        else
            for i in 1...(difference.abs)
                path << ((from_letter_ord + i).chr + (from_num - i).to_s).to_sym
            end
        end
        return path
    end

    def horizantal_check(cur_coord, new_coord)
        return nil if cur_coord[1] != new_coord[1]
        path = []
        return path if (new_coord[0].ord - cur_coord[0].ord) == 1
    
        num = cur_coord[1]
        min, max = 0, 0

        if new_coord[0].ord > cur_coord[0].ord
            min, max = ((cur_coord[0].ord) +1), (new_coord[0].ord)
        else
            min, max = ((new_coord[0].ord) +1), (cur_coord[0].ord)
        end

        for i in min...max 
            path << (i.chr + num).to_sym
        end

        return path
    end

    def en_passant?(cur_coord, new_coord, game_turn)
        cur_piece = @board[cur_coord]
        return false unless cur_piece.can_attack?(cur_coord,new_coord,game_turn)

        if @board[cur_coord].colour == :black
            return false if cur_coord[1].to_i != 4
        else
            return false if cur_coord[1].to_i != 5
        end

        opp_coord = ep_opp_coord(cur_coord,new_coord)
        return false if @board[opp_coord].nil?
        return false unless @board[opp_coord].is_a? Pawn
        return false unless (cur_piece.colour == :black && @board[opp_coord].colour == :white) || (cur_piece.colour == :white && @board[opp_coord].colour == :black)
        return false unless @board[opp_coord].turn_of_first_move == game_turn - 1

        true    
    end

    def ep_opp_coord(cur_coord,new_coord)
        if @board[cur_coord].colour ==:black
            opp_coord = (new_coord[0] + (new_coord[1].to_i + 1).to_s).to_sym
        else
            opp_coord = (new_coord[0] + (new_coord[1].to_i - 1).to_s).to_sym
        end
        opp_coord
    end

    def can_castle?(cur_coord,new_coord)

        cur_king = @board[cur_coord]
        cur_rook = nil
        rook_coord = nil

        #return false if cur_king.is_checked? == true  still need to write a method for is_checked?
        return false unless cur_coord[1] == new_coord[1]

        if (new_coord[0] == "c" || new_coord[0] == "g") && cur_king.never_moved
            if new_coord[0] == "c"
                rook_coord = ("a" + new_coord[1]).to_sym
                cur_rook = board[rook_coord]
            elsif new_coord[0] == "g"
                rook_coord = ("h" + new_coord[1]).to_sym
                cur_rook = @board[rook_coord]
            end

            return false unless cur_rook.is_a? Rook
            return false unless cur_rook.never_moved
            return false if cur_rook.colour != cur_king.colour
            return false unless clear_path?(cur_coord,new_coord)

            return true
        end
        false
    end

    def update_rook_after_castle(new_coord)
        if new_coord[0] == "c"
            rook_cur_coord = ("a" + new_coord[1]).to_sym
            rook_new_coord = ("d" + new_coord[1]).to_sym
        elsif new_coord[0] == "g"
            rook_cur_coord = ("h" + new_coord[1]).to_sym
            rook_new_coord = ("f" + new_coord[1]).to_sym
        end

        cur_rook = @board[rook_cur_coord]
        cur_rook.never_moved = false
        move_piece(rook_cur_coord,rook_new_coord)

        rook_new_coord
    end
end

    

