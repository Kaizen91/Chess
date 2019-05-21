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

    describe "#can_castle?" do

        it "changes the positions of the king and rook" do
            @@b.move_piece(:g1,:b3)
            @@b.move_piece(:f1,:c3)
            expect(@@b.can_castle?(:e1,:g1)).to eq true
        end

        it "doesn't change the positions of the king and rook if king has moved" do
            @@b.move_piece(:g1,:b3)
            @@b.move_piece(:f1,:c3)
            @@b.get_coord(:e1).never_moved = false
            expect(@@b.can_castle?(:e1,:g1)).to eq false
        end
    end
end