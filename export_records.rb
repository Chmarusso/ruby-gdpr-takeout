require 'csv'

module GDPR
  class ExportRecords
    class << self
      def call(path, records, exclude_columns)
        return if records.empty?

        filename = generate_filename(path, records.first)
        columns = get_column_names(records.first, exclude_columns)

        CSV.open(filename, 'w', write_headers: true, headers: columns) do |csv|
          records.find_each do |record|
            csv << columns.map {|c| record.read_attribute(c)}
          end
        end
      end

      private

      def generate_filename(path, record)
        File.join(path, "#{record.class.table_name}.csv")
      end

      def get_column_names(record, exclude_columns)
        column_names = record.class.column_names
        exclude_columns.each do |col|
          column_names.delete(col)
        end
        column_names
      end
    end
  end
end
