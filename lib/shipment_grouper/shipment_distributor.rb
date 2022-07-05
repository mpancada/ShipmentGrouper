class ShipmentDistributor
    Shipment = Struct.new(:ref, :total_weight, :clients_in_process_list) { self::MAX_WEIGHT = 2311 }

    def initialize
        @ref = 1
        @shipments = []
    end

    def get_indexed_distribution_per_client clients_in_process
        result = {}

        cip_desc = clients_in_process.sort {|a,b| b.total_weight <=> a.total_weight}
        cip_desc.each do |client_in_process|
            calc_distribution client_in_process
        end

        # Assuming that its NOT possible for 1 client to have more than Shipment::MAX_WEIGHT in parcels
        # I just need to index client => shipment
        @shipments.each do |shipment|
            shipment.clients_in_process_list.each{ |a| result[a.client_name] = shipment.ref }
        end

        result
    end

    private

    # TODO think of a better algoritm ot ensure minimum shipments
    def calc_distribution client_in_process
        @shipments.each do |shipment|
            next if shipment.total_weight + client_in_process.total_weight > Shipment::MAX_WEIGHT

            shipment.clients_in_process_list << client_in_process
            shipment.total_weight += client_in_process.total_weight
            return
        end

        @shipments << Shipment.new("shipment #{@ref}", client_in_process.total_weight, [client_in_process])
        @ref += 1
    end
end
