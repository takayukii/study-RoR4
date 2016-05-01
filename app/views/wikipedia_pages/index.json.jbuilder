json.array!(@wikipedia_pages) do |wikipedia_page|
  json.extract! wikipedia_page, :id
  json.url wikipedia_page_url(wikipedia_page, format: :json)
end
