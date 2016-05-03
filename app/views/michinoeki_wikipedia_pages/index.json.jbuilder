json.array!(@michinoeki_wikipedia_pages) do |michinoeki_wikipedia_page|
  json.extract! michinoeki_wikipedia_page, :id
  json.url michinoeki_wikipedia_page_url(michinoeki_wikipedia_page, format: :json)
end
