require 'rails_helper'

describe DataSource::Stock::TribunalCommerce::Operation::PrepareImport do
  let(:stock_param) { create(:stock_tc, files_path: path_param) }
  subject { described_class.call(stock: stock_param) }

  context 'when no zip files are found in stock path' do
    let(:path_param) { Rails.root.join('spec', 'fixtures', 'tc', 'no_stocks_here') }

    it { is_expected.to be_failure }
    its([:error]) { is_expected.to eq("No stock units found in #{path_param}.") }
    its([:stock_units]) { is_expected.to be_nil }
    it 'does not persist any stock unit' do
      expect { subject }.not_to change(StockUnit, :count)
    end
  end

  context 'when file names do not match specified pattern' do
    let(:path_param) { Rails.root.join('spec', 'fixtures', 'tc', 'falsey_stocks') }

    it { is_expected.to be_failure }
    its([:error]) { is_expected.to eq("Unexpected filenames in #{path_param}.") }
    its([:stock_units]) { is_expected.to be_nil }
    it 'does not persist any stock unit' do
      expect { subject }.not_to change(StockUnit, :count)
    end
  end

  # 3 greffe's stock example inside this repo :
  # spec/fixtures/tc/stock/2018/04/12
  # ├── 0666_S1_20180412.zip
  # ├── 1234_S1_20180412.zip
  # └── 3141_S1_20180412.zip
  context 'when stock units are found' do
    let(:path_param) { Rails.root.join('spec', 'fixtures', 'tc', 'stock', '2018', '04', '12') }

    it 'saves each greffe\'s stock unit in db' do
      expect { subject }.to change(StockUnit, :count).by(3)
    end

    its([:stock_units]) { are_expected.to eq StockUnit.all }
    its([:stock_units]) { are_expected.to all(have_attributes(status: 'PENDING')) }
    its([:stock_units]) { are_expected.to all(be_persisted) }

    describe 'associated stock units' do
      it 'has valid code_greffe' do
        subject
        created_unit = StockUnit.where(code_greffe: '1234')
          .or(StockUnit.where(code_greffe: '3141'))
          .or(StockUnit.where(code_greffe: '0666'))

        expect(created_unit.size).to eq(3)
      end

      it 'knows its own path' do
        subject
        unit = StockUnit.where(code_greffe: '1234').first

        expect(unit.file_path).to end_with('spec/fixtures/tc/stock/2018/04/12/1234_S1_20180412.zip')
      end
    end
  end
end
