require 'csv'

require_relative 'parcel'
require_relative 'client_in_process'
require_relative 'shipment_distributor'

class Processor

    def initialize csv_path
        @csv_path = csv_path
        @csv_output = [] # Preserve CSV rows order, later will be updated with shipment_ref
        @clients_in_process_cache = {} # Used to group parcels and total_weight per client
        @client_to_shipment_indexed = {} # Used to get shipment_ref by client_name
    end

    def process
        CSV.foreach(@csv_path, col_sep: ',', headers: true) do |row|
            @csv_output << row
            build_clients_in_process(row)
        end

        @client_to_shipment_indexed = ShipmentDistributor.new.get_indexed_distribution_per_client(@clients_in_process_cache.values)
    end

    def write_to_csv path=nil
        path ||= "../#{Time.now.strftime '%Y-%m-%d_%H-%M-%S'}-output.csv"
        CSV.open(path, "wb", col_sep: ',') do |csv|
            csv << %w[parcel_ref client_name weight shipment_ref]

            @csv_output.each do |row|
                csv << (row << @client_to_shipment_indexed[row["client_name"]])
            end
        end
    end

    private

    def build_clients_in_process row
        @clients_in_process_cache[row["client_name"]] ||= ClientInProcess.new(row["client_name"])

        @clients_in_process_cache[row["client_name"]].add_parcel Parcel.new(row["parcel_ref"], row["weight"].to_i)
    end
end
