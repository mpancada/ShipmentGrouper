require_relative '../lib/shipment_grouper/client_in_process.rb'
require_relative '../lib/shipment_grouper/parcel.rb'

describe ClientInProcess do
  describe "Usage" do
    let(:cip) do
      cip = ClientInProcess.new("Dummy1")
      cip.add_parcel Parcel.new("AAAA", 2311)
      cip.add_parcel Parcel.new("BBBB", 1000)
      cip
    end

    it "Should have client_name return Dummy1" do
      expect(cip.client_name).to eql("Dummy1")
    end

    describe ".add_parcel" do
      it "First Parcel.ref = AAAA" do
        expect(cip.parcels_list.first.ref).to eql("AAAA")
      end

      it "total_weight = 3311" do
        expect(cip.total_weight).to eql(3311)
      end

      it "Should have 2 parcels" do
        expect(cip.parcels_list.length).to eql(2)
      end
    end
  end
end
