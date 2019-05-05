require "./Pieces.rb"
class Board

attr_accessor :board
    def initialize(board = create_board)
        @turn = :white
        @board = board
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
                    line = line.sub ".", "\e[47m #{print_piece(coord1)} \e[0m" #puts a white background and gets the piece representation
                    line = line.sub ".", "\e[40m #{print_piece(coord2)} \e[0m" #puts a black background and gets the piece representation
                else
                    line = line.sub ".", "\e[40m #{print_piece(coord1)} \e[0m" #puts a black background and gets the piece representation
                    line = line.sub ".", "\e[47m #{print_piece(coord2)} \e[0m" #puts a white background and gets the piece representation
                end
            end
            line
        end

        middle_line  = ("  "+ "┣━━━" * 8 + "┫")
        bottom_line  = ("  " + "````" * 8 + "  ")

        body= basic_lines.join("\n" + middle_line + "\n")
        
        visualized_board = [horizantal_coordinates, topline, body, bottom_line, horizantal_coordinates].join("\n")
    end

=begin
    def take_piece(start_coord,target_coord)
        if target_coord
    end
=end

    
end

