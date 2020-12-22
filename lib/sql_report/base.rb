# frozen_string_literal: true

module SQLReport
  class Base
    mattr_accessor :adapter, instance_writer: false

    class_attribute :periods, instance_writer: false, default: {
      month: "to_char('YYYY-MM', ?)"
    }
    class_attribute :selects, instance_writer: false, default: []
    class_attribute :columns, instance_writer: false, default: []

    attr_accessor :columns, :rows, :compare_rows, :grouped_by

    # DSL

    private_class_method def self.select(from_item, columns:, as: nil, where: nil)
      selects << {
        from_item: from_item,
        alias: as || from_item,
        columns: columns,
        where: where
      }
    end

    private_class_method def self.column(output_name, expression)
      columns[output_name] = expression
    end

    def self.inherited(sub)
      sub.periods = periods.dup
      sub.selects = selects.dup
      sub.columns = columns.dup

      super
    end

    # Query methods

    def self.by_period(period)
      raise ArgumentError unless [:month, :quarter, :year].include?(period)
    end

    def self.compare_period_year_on_year(period)
      raise ArgumentError unless [:month, :quarter].include?(period)
    end

    def self.totals
    end

    def self.grouped_by(expression)
    end
  end
end
