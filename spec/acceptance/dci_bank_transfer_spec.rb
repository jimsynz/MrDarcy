require 'spec_helper'

class BankTransfer < MrDarcy::Context
  role :money_source do
    def has_available_funds? amount
      available_balance >= amount
    end

    def subtract_funds amount
      self.available_balance = available_balance - amount
    end
  end

  role :money_destination do
    def receive_funds amount
      self.available_balance = available_balance + amount
    end
  end

  action :transfer do |amount|
    if money_source.has_available_funds? amount
      money_source.subtract_funds amount
      money_destination.receive_funds amount
    else
      raise "insufficient funds"
    end
    amount
  end
end

Account = Struct.new(:available_balance)

describe 'DCI Bank Transfer' do
  let(:money_source)      { Account.new source_balance }
  let(:money_destination) { Account.new destination_balance }

  MrDarcy.all_drivers.each do |driver|
    describe "Driver #{driver}" do
      let(:context) { BankTransfer.new money_source: money_source, money_destination: money_destination, driver: driver }

      When 'the source balance is 10' do
        let(:source_balance) { 10 }

        And 'the destination balance is 5' do
          let(:destination_balance) { 5 }

          When 'I transfer 8' do
            subject { context.transfer(8).final }

            its('money_source.available_balance')      { should eq 2 }
            its('money_destination.available_balance') { should eq 13 }
            its(:result) { should eq 8 }
          end
        end
      end
    end
  end
end
