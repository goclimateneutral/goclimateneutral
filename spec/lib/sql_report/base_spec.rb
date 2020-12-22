# frozen_string_literal: true

require 'rails_helper'
require 'sql_report'

RSpec.describe SQLReport::Base do
  let(:query_result) { ActiveRecord::Result.new }
  before do
    described_class.adapter = double('Test adapter')
    allow(described_class.adapter).to receive(:execute).and_return(query_result)

    stub_const 'TestReport', Class.new(described_class)
    stub_const 'OtherTestReport', Class.new(described_class)
  end

  describe '.select' do
    it 'adds select to the class configuration' do
      TestReport.class_eval do
        select :some_table, as: :signups, columns: { count: 'count(id)' }, where: 'subscription_id IS NOT NULL'
      end

      expect(TestReport.selects).to include(
        hash_including(
          from_item: :some_table,
          alias: :signups,
          columns: { count: 'count(id)' },
          where: 'subscription_id IS NOT NULL'
        )
      )
    end

    it 'uses from_item as alias if no alias is given' do
      TestReport.class_eval do
        select :some_table, columns: { count: 'count(id)' }, where: 'subscription_id IS NOT NULL'
      end

      expect(TestReport.selects).to include(hash_including(alias: :some_table))
    end

    it 'isolates configured select clauses between classes' do
      TestReport.class_eval do
        select :some_table, columns: { count: 'count(id)' }
      end

      OtherTestReport.class_eval do
        select :other_table, columns: { count: 'count(id)' }
      end

      expect(TestReport.selects.map { |i| i[:from_item] }).to eq([:some_table])
    end
  end

  describe '.totals' do
  end
end
