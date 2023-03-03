require_relative 'cash_counter'
require 'rspec'

RSpec.describe CashCounter do
  let(:cash_counter) { CashCounter.new }
  describe 'CashCounter' do
    it 'run cash counter and check for successfull execution' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return("milk,milk, bread,banana,bread,bread,bread,milk,apple\n")
      expect { cash_counter.run }.to output(/Total price/).to_stdout
    end

    it 'run cash counter and check for exception handling' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return("milk,milk, broad\n")
      expect { cash_counter.run }.to output(/Something went Wrong!/).to_stdout
    end
  end
end
