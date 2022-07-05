class ClientInProcess
    attr_reader :client_name, :parcels_list, :total_weight

    def initialize client_name
        @client_name = client_name
        @parcels_list = []
        @total_weight = 0
    end

    def add_parcel parcel
        @total_weight += parcel.weight
        @parcels_list << parcel
    end
end
