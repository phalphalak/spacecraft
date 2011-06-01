
require 'spec_helper'
require 'space_craft/model/grid'


describe SpaceCraft::Model::Grid do

  context "initialized with a width of 3 and a height of 5" do

    before(:each) do
      @grid = SpaceCraft::Model::Grid.new(3,5)
    end

    describe "#width" do
      it "returns 3" do
        @grid.width.should be(3)
      end
    end

    describe "#height" do
      it "returns 5" do
        @grid.height.should be(5)
      end
    end

    context "given X in (0..2) and Y in (0..4)" do
      describe "#[]" do
        it "returns nil" do
          3.times{|x| 5.times {|y| @grid[x,y].should be_nil }}
        end
      end

      describe "#[]=" do
        it "sets a given value only for coordiantes X,Y" do
          @grid[2,1] = 1          
          @grid[2,1].should eq(1)
          3.times{|x| 5.times {|y| @grid[x,y].should be_nil unless [x,y] == [2,1] }}
        end
      end
    end

    context "given X and/or Y outside of a valid range" do
      describe "#[]" do
        it "raises" do
          [[-1,-2],[-1,1],[-1,6],[0,5],[0,-1],[3,-1],[3,0],[3,5]].each do |x,y|
            expect {@grid[x,y]}.to raise_error
          end
        end
      end

      describe "#[]=" do
        it "raises" do
          [[-1,-2],[-1,1],[-1,6],[0,5],[0,-1],[3,-1],[3,0],[3,5]].each do |x,y|
            expect {@grid[x,y] = 1}.to raise_error
          end
        end
      end
    end


  end
end
