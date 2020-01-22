# frozen_string_literal: true

require_relative '../banana_fetcher'

describe BananaFetcher do
  it 'fetches bananas with default params' do
    list = [{:id => 1, :name => "banana 1"},
            {:id => 2, :name => "banana 2"},
            {:id => 3, :name => "banana 3"},
            {:id => 4, :name => "banana 4"},
            {:id => 5, :name => "banana 5"},
            {:id => 6, :name => "banana 6"},
            {:id => 7, :name => "banana 7"},
            {:id => 8, :name => "banana 8"},
            {:id => 9, :name => "banana 9"},
            {:id => 10, :name => "banana 10"}]
    expect(BananaFetcher.new.fetch).to eq list
  end

  it 'fetches 3 bananas on second page' do
    list = [{:id => 4, :name => "banana 4"},
            {:id => 5, :name => "banana 5"},
            {:id => 6, :name => "banana 6"}
           ]
    expect(BananaFetcher.new.fetch(1, 3)).to eq list
  end

  it 'filters bananas' do
    list = [{:id => 4, :name => "banana 4"}]
    expect(BananaFetcher.new.fetch(0, 3, { id: 4 } )).to eq list
  end

  it 'provides no bananas on external error' do
    fetcher = BananaFetcher.new
    fetcher.collection = nil # external api error
    expect(fetcher.fetch(1, 3)).to eq []
  end

  it 'provides no bananas on out of bound' do
    fetcher = BananaFetcher.new
    fetcher.collection = fetcher.seed[0...3] # external api error
    expect(fetcher.fetch(15, 30)).to eq []
  end

  it 'provides all existing bananas if you request more then it has' do
    fetcher = BananaFetcher.new
    fetcher.collection = fetcher.seed[0...3] # external api error
    expect(fetcher.fetch(0, 30).count).to eq 3
  end

  it 'provides cached bananas' do
    fetcher = BananaFetcher.new
    bananas = fetcher.fetch_with_cache
    fetcher.collection = fetcher.seed[11...30]
    # and the biggest flaw - inconsistency is seen here
    new_bananas = fetcher.fetch_with_cache
    expect(bananas).to eq new_bananas
  end
end