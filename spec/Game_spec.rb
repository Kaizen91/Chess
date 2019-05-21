require "./Board.rb"
require "./Pieces.rb"
require "./Game.rb"

describe Game do 
    subject(:game)  {Game.new}

    describe "#valid_and_occupied?" do
        it "returns false if square is unoccupied" do 
            expect(game.valid_and_occupied?(:a4)).to eq false
        end

        it "returns false if square is out of bounds by rank" do 
            expect(game.valid_and_occupied?(:j4)).to eq false
        end

        it "returns false if square is out of bounds by file" do 
            expect(game.valid_and_occupied?(:a9)).to eq false
        end

        it "returns true if square is in bounds and valid" do 
            expect(game.valid_and_occupied?(:a2)).to eq true
        end
    end

    describe "#valid_coord?" do

        it "returns false if square is out of bounds by rank" do 
            expect(game.valid_coord?(:j4)).to eq false
        end

        it "returns false if square is out of bounds by file" do 
            expect(game.valid_coord?(:a9)).to eq false
        end

        it "returns true if square is in bounds" do 
            expect(game.valid_coord?(:a4)).to eq true
        end
    end

    describe "#right_coloured_piece?" do
        
        it "returns true on a white piece when the turn is white" do
            expect(game.right_coloured_piece?(:white,:a2)).to eq true
        end

        it "returns false on a black piece when the turn is white" do
            expect(game.right_coloured_piece?(:white,:h7)).to eq false
        end
        
            
        it "returns true on a black piece when the turn is black" do
                
                expect(game.right_coloured_piece?(:black,:h7)).to eq true
        end

         it "returns false on a white piece when the turn is black" do
                
                expect(game.right_coloured_piece?(:black,:a2)).to eq false
         end
        
    end

    describe "#free_way?" do
            
        it "returns false if there is a piece in the way" do
            expect(game.free_way?(:d1,:d3)).to eq false
        end

        it "retruns true if there is not a piece in the way" do 
            game.board.move_piece(:g2,:g3)
            expect(game.free_way?(:f1,:h3)).to eq true
        end

        it "returns true if the piece is a knight" do 
            expect(game.free_way?(:b1,:c3)).to eq true
        end
    end
end

