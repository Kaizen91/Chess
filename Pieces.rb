class Piece
    attr_accessor :colour, :symbol

    def initialize(colour)
        @colour = colour
    end

    def colour_check
        self.colour == :white ? true : false
    end

    def pawn_moves(cur_coord,new_coord)
        return false if cur_coord[0] != new_coord[0]
        if self.colour == :white
          return false unless (cur_coord[1].to_i + 1 == new_coord[1].to_i) ||
                              (cur_coord[1].to_i + 2 == new_coord[1].to_i)
          return false if (cur_coord[1].to_i + 2 == new_coord[1].to_i) && !(cur_coord[1].to_i == 2)
        else
          return false unless (cur_coord[1].to_i - 1 == new_coord[1].to_i) ||
                              (cur_coord[1].to_i - 2 == new_coord[1].to_i)
          return false if (cur_coord[1].to_i - 2 == new_coord[1].to_i) && !(cur_coord[1].to_i == 7)
        end
    
        return true
    end

    def rook_moves(cur_coord,new_coord)
        return false unless ((cur_coord[0] == new_coord[0] && cur_coord[1] != new_coord[1]) || (cur_coord[0] != new_coord[0] && cur_coord[1] == new_coord[1])) #only move horizantal and vertical
        return true
    end

    def knight_moves(cur_coord,new_coord)
        to_add = [[-1,-2],[1,-2],[1,2],[-1,2],[2,-1],[2,1],[-2,1],[-2,-1]]
        possible_new_coords = to_add.map do |el|
            ( (cur_coord[0].ord + el[0]).chr + (cur_coord[1].to_i + el[1]).to_s).to_sym
        end
        return possible_new_coords.include?(new_coord)
    end
    
    def bishop_moves(cur_coord,new_coord)
        return false unless ((cur_coord[0].ord - new_coord[0].ord).abs == (cur_coord[1].to_i - new_coord[1].to_i).abs)
        return true
    end

    def king_moves(cur_coord,new_coord)
        to_add = [[-1,-1],[-1,0],[-1,1],[0,1],[0,-1],[1,1],[0,1],[-1,1]]
        possible_new_coords = to_add.map do |el|
            (((cur_coord[0].ord) + el[0]).chr + (cur_coord[1].to_i + el[1]).to_s).to_sym
        end
        return possible_new_coords.include?(new_coord)
    end

    def can_move?(cur_coord, new_coord)
        case self.class.to_s
        when 'Pawn'
            pawn_moves(cur_coord,new_coord) ? true : false
        when 'Rook'
            rook_moves(cur_coord,new_coord) ? true : false
        when 'Knight'
            knight_moves(cur_coord,new_coord) ? true : false
        when 'Bishop'
            bishop_moves(cur_coord,new_coord) ? true : false
        when 'King'
            king_moves(cur_coord,new_coord) ? true : false
        when 'Queen'
            return (rook_moves(cur_coord,new_coord) || (bishop_moves(cur_coord,new_coord)))
        else
            return false
        end
    end
end

class Pawn < Piece
    def initialize(colour)
        super(colour)
        @symbol = colour_check ? "P" : "p"
    end
end

class Rook < Piece
    def initialize(colour)
        super(colour)
        @symbol = colour_check ? "R" : "r"
    end

end

class Knight < Piece
    def initialize(colour)
        super(colour)
        @symbol = colour_check ? "N" : "n"
    end

end

class Bishop < Piece
    def initialize(colour)
        super(colour)
        @symbol = colour_check ? "B" : "b"
    end

end

class King < Piece
    def initialize(colour)
        super(colour)
        @symbol = colour_check ? "K" : "k"
    end

end

class Queen < Piece
    def initialize(colour)
        super(colour)
        @symbol = colour_check ? "Q" : "q"
    end
end
