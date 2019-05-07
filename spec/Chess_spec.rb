require "./Board.rb"
require "./Pieces.rb"
require "./Game.rb"
describe Board do
    context "#create_board" do
        subject(:b) { Board.new }
        it { expect(b.board[:a2]).to be_instance_of Pawn}
        it { expect(b.board[:a2].colour).to eq :white}
        it { expect(b.board[:a7]).to be_a Pawn}
        it { expect(b.board[:a7].colour).to eq :black}
    end

    context "#move_piece" do
        @@b = Board.new
        @@b.board[:a2] = Pawn.new(:white)
        @@b.board[:a3] = Pawn.new(:black)
        @@b.move_piece(:a2,:a3)
        it "moves a piece from one coord to another" do
        expect(@@b.board[:a2]).to be_nil
        end
        
        it "takes a piece" do 
            expect(@@b.board[:a3].colour).to eq :white
        end
   
    end
=begin
    context "#take_piece" do
        @@b.board[:a1] = Bishop.new(:white)
        @@b.board[:d4] = Pawn.new(:black)
        @@b.take_piece(:a1,:d4)
        it {expect(@@b.board[:a1]).to be_nil}
        it {expect(@@b.board[:d4]).to be_instance_of Bishop}
        it {expect(@@b.board[:d4].colour).to eq :black}
    end
=end


end

describe Piece do 
    context "#can_move?" do
        subject(:pawn) {Pawn.new(:white)}
        subject(:rook) {Rook.new(:white)}
        subject(:knight) {Knight.new(:white)}
        subject(:bishop) {Bishop.new(:white)}
        subject(:king) {King.new(:white)}
        subject(:queen) {Queen.new(:white)}


        #Pawn tests
        it "Pawn can move one space forward" do
            expect(pawn.can_move?(:a2,:a3)).to eq true 
        end
        it "Pawn can move two spaces forward on first move" do
            expect(pawn.can_move?(:a2,:a4)).to eq true 
        end
        it "Pawn can't move like a bishop" do
         expect(pawn.can_move?(:a2,:d3)).to eq false
        end
        
        
        #Rook tests
        it "Rook can move along it's file" do
        expect(rook.can_move?(:a2,:a8)).to eq true 
        end
        it "Rook can move along it's rank" do
        expect(rook.can_move?(:a2,:h2)).to eq true 
        end
        it "Rook can't move like a Bishop" do
        expect(rook.can_move?(:a2,:b3)).to eq false
        end
      
        #Knight tests
        it "Knight moves in an L" do
        expect(knight.can_move?(:a2,:c3)).to eq true 
        end
        it "Knight doesn't move like a Bishop" do 
            expect(knight.can_move?(:a2,:a3)).to eq false
        end
        
        #Bishop Tests
        it "Bishop can move diagonally" do
            expect(bishop.can_move?(:a2,:c4)).to  eq true 
        end
        it "Bishop cannot move like a Rook" do 
            expect(bishop.can_move?(:a2,:a3)).to eq false 
        end

        #King Test
        it "King can move one space" do
            expect(king.can_move?(:a2,:a3)).to eq true 
        end
        it "King can't move two spaces" do
            expect(king.can_move?(:a2,:a4)).to eq false 
        end
       
        #Queen test
       
        it "Queen can move diagonally" do
            expect(queen.can_move?(:a1,:h8)).to eq true 
        end
       
        it "Queen can move vertically" do
            expect(queen.can_move?(:a2,:a8)).to eq true
        end
        it "Queen can move horizantally" do
            expect(queen.can_move?(:a1,:h1)).to eq true 
        end
        it "Queen can't move in Ls" do
        expect(queen.can_move?(:a1,:b3)).to eq false
        end
    end
end

describe Pawn do
    subject(:p) {Pawn.new(:white)}
    it {expect(p.colour).to eq :white}
    it {expect(p.symbol).to eq "P"}
end
