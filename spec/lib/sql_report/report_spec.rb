# frozen_string_literal: true

require 'rails_helper'
require 'sql_report'

RSpec.describe SQLReport::Report do
  describe '#select' do
    it 'adds select clauses to the class configuration' do
    end

    it 'isolates configured select clauses between classes' do
      class A < SQLReport::Report
        select :some_table, columns: { count: 'count(id)' }
      end

      class B < SQLReport::Report
        select :other_table, columns: { count: 'count(id)' }
      end

      expect(A._sources.keys).to eq([:some_table])
    end
  end
end
