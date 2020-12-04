# frozen_string_literal: true

module SQLReport
  class Report
    class_attribute :_sources, default: {}
    class_attribute :_columns, default: {}

    def self.select(from_item, columns:, as: nil, where: nil)
      _sources[(as || from_item).to_sym] = {
        columns: columns,
        where: where
      }
    end

    def self.column(output_name, expression)
      _columns[output_name] = expression
    end
  end
end
