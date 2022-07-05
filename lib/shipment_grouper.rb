require_relative 'shipment_grouper/processor'

processor = Processor.new(ARGV[0])
processor.process
processor.write_to_csv
