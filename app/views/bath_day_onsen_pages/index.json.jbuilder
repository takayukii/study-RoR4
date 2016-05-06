json.array!(@bath_day_onsen_pages) do |bath_day_onsen_page|
  json.extract! bath_day_onsen_page, :id
  json.url bath_day_onsen_page_url(bath_day_onsen_page, format: :json)
end
