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
        subject(:pawn) {Pawn.new}
        context "pawn moves one space or two spaces forward" do 
        it {expect(pawn.can_move?(:a2,:a3)).to be_true }
        it {expect(pawn.can_move?(:a2,:a4)).to be_true }
        end
        context "pawn doesn't move incorrectly" do
        it {expect(pawn.can_move?(:a2,:d3)).to be_false}
        end
        subject(:rook) {Rook.new}
        context "rook moves along verticles and horizantals" do
        it {expect(rook.can_move?(:a2,:a8)).to be_true }
        it {expect(rook.can_move?(:a2,:h2)).to be_true }
        end
        context "rook doesn't move horizantally"do
        it {expect(rook.can_move?(:a2,:b3)).to be_false}
        end
        subject(:knight) {Knight.new}
        context "knights move in Ls" do
        it {expect(knight.can_move?(:a2,:c3)).to be_true }
        it {expect(knight.can_move?(:a2,:a3)).to be_false}
        end
        subject(:bishop) {Bishop.new}
        context "bishops move along diagonals" do
        it {expect(bishop.can_move?(:a2,:c4)).to  be_true }
        end
        context "bishops can move horizantally" do
        it {expect(bishop.can_move?(:a2,:a3)).to be_false }
        end
        subject(:king) {King.new}
        context "kings move one space around themselves" do
        it {expect(king.can_move?(:a2,:a3)).to be_true }
        it {expect(king.can_move?(:a2,:a4)).to be_false }
        end
        subject(:queen) {Queen.new}
        context "queens can move horizantally" do
        it {expect(queen.can_move?(:a1,:h8)).to be_true }
        end
        context "queens can move vertically" do
        it {expect(queen.can_move?(:a2,:a8)).to be_true}
        end
        context "queens can move diagonally" do 
        it {expect(queen.can_move?(:a1,:h1)).to be_true }
        end
        context "queens can't move in Ls" do
        it {expect(queen.can_move?(:a1,:b3)).to be_false}
        end
    end
end

describe Pawn do
    subject(:p) {Pawn.new(:white)}
    it {expect(p.colour).to eq :white}
    it {expect(p.symbol).to eq "P"}
end
