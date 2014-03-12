require 'spec_helper'

class TransferFunds < MrDarcy::Context
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

describe 'TransferFunds DCI' do
  let(:driver)              { :thread }
  let(:source_balance)      { 0 }
  let(:destination_balance) { 0 }
  let(:money_source)        { Account.new(source_balance) }
  let(:money_destination)   { Account.new(destination_balance) }
  let(:context)             { TransferFunds.new money_source: money_source, money_destination: money_destination, driver: driver }
  subject { context }

  it { should be_a TransferFunds }
  it { should be_a MrDarcy::Context }

  When 'the source balance is 15' do
    let(:source_balance) { 15 }
    subject { run_transfer }

    And 'the destination balance is 13' do
      let(:destination_balance) { 13 }

      And 'we transfer 5' do
        let(:run_transfer) { context.transfer(5).final }

        its('money_source.available_balance')      { should eq 10 }
        its('money_destination.available_balance') { should eq 18 }
        its(:rejected?)   { should be_false }
        its(:resolved?)   { should be_true }
        its(:unresolved?) { should be_false }
      end

      And 'we transfer 5 then' do
        let(:run_transfer) { context.transfer(5).transfer(3).final }

        its('money_source.available_balance')      { should eq 7 }
        its('money_destination.available_balance') { should eq 21 }
        its(:rejected?)   { should be_false }
        its(:resolved?)   { should be_true }
        its(:unresolved?) { should be_false }
      end

      And 'we transfer 30' do
        let(:run_transfer) { context.transfer(30).final }

        its('money_source.available_balance')      { should eq 15 }
        its('money_destination.available_balance') { should eq 5 }
        its(:rejected?)   { should be_true }
        its(:resolved?)   { should be_false }
        its(:unresolved?) { should be_false }
        its(:result)      { should be_an Exception }
      end
    end
  end
end
