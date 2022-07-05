require_relative '../lib/shipment_grouper/processor.rb'
require 'tempfile'

describe Processor do
  describe "Usage" do
  	let(:input_csv) do
  		input_csv = CSV.generate(col_sep: ',') do |csv|
  			csv << %w[parcel_ref client_name weight]
  			csv << %w[AAAA Dummy1 1311]
  			csv << %w[BBBB Dummy1 1000]
  			csv << %w[CCCC Dummy2 1000]
  			csv << %w[DDDD Dummy3 1000]
  		end

  		tp = Tempfile.new
  		tp << input_csv
  		tp.rewind
  		tp
  	end
  	let(:output_csv) { Tempfile.new }
  	before do
  		@processor = Processor.new input_csv.path
  		@processor.process
  		@processor.write_to_csv output_csv.path
  	end
  	
  	describe ".process" do
  		it "should have 3 clients grouped" do
  			expect(@processor.instance_variable_get(:@clients_in_process_cache).keys.length).to eql(3)
  		end
  	end
  	
  	describe ".write_to_csv output_csv.path" do
  		it "should be equal" do
  			expect(CSV.read(output_csv.path, col_sep: ',')).to eql([
  				["parcel_ref", "client_name", "weight", "shipment_ref"],
				["AAAA", "Dummy1", "1311", "shipment 1"],
				["BBBB", "Dummy1", "1000", "shipment 1"],
				["CCCC", "Dummy2", "1000", "shipment 2"],
				["DDDD", "Dummy3", "1000", "shipment 2"]
  			])
  		end

  		it "should have same order as input_csv" do
  			expect(CSV.read(input_csv.path, col_sep: ',')).to eql(CSV.read(output_csv.path, col_sep: ',').map{|a| a.pop; a})
  		end
  	end
  end
end
