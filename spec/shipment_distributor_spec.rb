require_relative '../lib/shipment_grouper/shipment_distributor'
require_relative '../lib/shipment_grouper/client_in_process.rb'
require_relative '../lib/shipment_grouper/parcel.rb'

describe ShipmentDistributor do
  describe "Usage" do
    before do
      clients_in_process_cache = {
        "Dummy1" => ClientInProcess.new("Dummy1"),
        "Dummy2" => ClientInProcess.new("Dummy2"),
        "Dummy3" => ClientInProcess.new("Dummy3")
      }
      clients_in_process_cache["Dummy1"].add_parcel Parcel.new("AAAA", 1311)
      clients_in_process_cache["Dummy1"].add_parcel Parcel.new("BBBB", 1000)
      clients_in_process_cache["Dummy2"].add_parcel Parcel.new("CCCC", 1000)
      clients_in_process_cache["Dummy3"].add_parcel Parcel.new("DDDD", 1000)

      @sp = ShipmentDistributor.new
      @client_to_shipment_indexed = @sp.get_indexed_distribution_per_client(clients_in_process_cache.values)
    end

    describe ".get_indexed_distribution_per_client(clients_in_process_cache.values)" do
      it "Should have 2 shipments" do
        expect(@sp.instance_variable_get(:@shipments).length).to eql(2)
      end

      it "Should be eql" do
        expect(@client_to_shipment_indexed).to eql({
          "Dummy1" => "shipment 1",
          "Dummy2" => "shipment 2",
          "Dummy3" => "shipment 2"
        })
      end
    end
  end
end
