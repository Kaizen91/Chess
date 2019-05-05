class Piece
    attr_accessor :colour, :symbol

    def initialize(colour)
        @colour = colour
    end

    def colour_check
        self.colour == :white ? true : false
    end

    def can_move?
        
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