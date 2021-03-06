require 'spec_helper'

RSpec.describe 'Korbit integration specs' do
  client = Cryptoexchange::Client.new

  it 'fetch pairs' do
    pairs = client.pairs('korbit')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to eq 'BTC'
    expect(pair.target).to eq 'KRW'
    expect(pair.market).to eq 'korbit'
  end

  context 'fetch ticker' do
    before(:all) do
      btc_krw_pair = Cryptoexchange::Models::MarketPair.new(base: 'BTC', target: 'KRW', market: 'korbit')
      @ticker = client.ticker(btc_krw_pair)
    end
    it { expect(@ticker.base).to eq 'BTC' }
    it { expect(@ticker.target).to eq 'KRW' }
    it { expect(@ticker.market).to eq 'korbit' }
    it { expect(@ticker.last).to_not be nil }
    it { expect(@ticker.bid).to_not be nil }
    it { expect(@ticker.ask).to_not be nil }
    it { expect(@ticker.high).to_not be nil }
    it { expect(@ticker.volume).to_not be nil }
    it { expect(@ticker.timestamp).to_not be nil }
    it { expect(@ticker.payload).to_not be nil }
  end
end
