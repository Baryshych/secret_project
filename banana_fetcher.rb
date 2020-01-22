# frozen_string_literal: true

# fetching bananas information from the api
class BananaFetcher

  attr_accessor :collection
  attr_reader :seed

  def initialize
    @seed = (1..1000).to_a.map {|x| {name: 'banana ' + x.to_s, id: x}}
    @collection = @seed
  end

  def fetch(page_offset = 0,
            per_page = 10,
            filter = {})
    return [] unless @collection

    filtered = @collection
    filter.each do |key, value|
      filtered = filtered.select { |banana| banana[key] == value }
    end
    filtered[page_offset * per_page...(page_offset + 1) * per_page] || []
  end

  def fetch_with_cache(page_offset = 0,
                       per_page = 10,
                       filter = {})
    @cache ||= {
        query: {},
        data: {}
    }
    query = { page_offset: page_offset, per_page: per_page, filter: filter }
    unless @cache[:query] == query
      p 'Loading...'
      @cache[:data] = fetch(page_offset, per_page, filter)
      @cache[:query] = query
    end
    @cache[:data]
    end
  
  def fetch_with_lookback_cache(page_offset = 0,
                       per_page = 10,
                       filter = {})
    @cache ||= [{
        query: [],
        data: []
    }]
    query = { page_offset: page_offset, per_page: per_page, filter: filter }
    cached = @cache.find{|cached| cached[:query] == query}
    unless cached
      p 'Loading...'
      cached = { data: fetch(page_offset, per_page, filter), query: query}
      @cache << cached
    end
    cached
  end
end