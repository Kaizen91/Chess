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

    context "#in_bounds?" do 
        it "returns false when a value is out of bounds" do 
            expect(in_bounds?(g9)).to eq false
        end
        it "returns true when a value is in bounds" do
            expect(in_bounds?(a3)).to eq true
        end
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