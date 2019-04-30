require "./Chess.rb"

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
        @@b.move_piece(:a2,:a3)
        it "takes moves a piece from one coord to another" do
        expect(@@b.board[:a2]).to be_nil
        end
    end

end

describe Pawn do
    subject(:p) {Pawn.new(:white)}
    it {expect(p.colour).to eq :white}
    it {expect(p.symbol).to eq "P"}
end

