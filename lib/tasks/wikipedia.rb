require 'kconv'
require 'pp'

class Tasks::Wikipedia

  # Crawl
  def self.crawl

    urls = %w(
        https://ja.wikipedia.org/wiki/%E9%81%93%E3%81%AE%E9%A7%85%E4%B8%80%E8%A6%A7_%E5%8C%97%E6%B5%B7%E9%81%93%E5%9C%B0%E6%96%B9
        https://ja.wikipedia.org/wiki/%E9%81%93%E3%81%AE%E9%A7%85%E4%B8%80%E8%A6%A7_%E6%9D%B1%E5%8C%97%E5%9C%B0%E6%96%B9
        https://ja.wikipedia.org/wiki/%E9%81%93%E3%81%AE%E9%A7%85%E4%B8%80%E8%A6%A7_%E9%96%A2%E6%9D%B1%E5%9C%B0%E6%96%B9
        https://ja.wikipedia.org/wiki/%E9%81%93%E3%81%AE%E9%A7%85%E4%B8%80%E8%A6%A7_%E4%B8%AD%E9%83%A8%E5%9C%B0%E6%96%B9
        https://ja.wikipedia.org/wiki/%E9%81%93%E3%81%AE%E9%A7%85%E4%B8%80%E8%A6%A7_%E5%8C%97%E9%99%B8%E5%9C%B0%E6%96%B9
        https://ja.wikipedia.org/wiki/%E9%81%93%E3%81%AE%E9%A7%85%E4%B8%80%E8%A6%A7_%E8%BF%91%E7%95%BF%E5%9C%B0%E6%96%B9
        https://ja.wikipedia.org/wiki/%E9%81%93%E3%81%AE%E9%A7%85%E4%B8%80%E8%A6%A7_%E4%B8%AD%E5%9B%BD%E5%9C%B0%E6%96%B9
        https://ja.wikipedia.org/wiki/%E9%81%93%E3%81%AE%E9%A7%85%E4%B8%80%E8%A6%A7_%E5%9B%9B%E5%9B%BD%E5%9C%B0%E6%96%B9
        https://ja.wikipedia.org/wiki/%E9%81%93%E3%81%AE%E9%A7%85%E4%B8%80%E8%A6%A7_%E4%B9%9D%E5%B7%9E%E5%9C%B0%E6%96%B9
    )

    options = {
        :delay => 1,
        :depth_limit => 2,
    }

    Anemone.crawl(urls, options) do |anemone|

      # Filter links to follow
      anemone.focus_crawl do |page|
        doc = Nokogiri::HTML.parse(page.body.toutf8)
        title = doc.at('title').inner_html.to_s

        if title.match(/道の駅一覧/)
          links = self.focus_michinoeki_page(doc, page.url)
        else
          links = self.focus_geohack_page(doc)
        end
        links
      end

      # Scraping HTML
      anemone.on_every_page do |page|

        doc = Nokogiri::HTML.parse(page.body.toutf8)
        title = doc.at('title').inner_html.to_s
        puts "process #{title}"

        if title.match(/道の駅一覧/)
          next
        end

        if title.match(/^道の駅.+Wikipedia/)

          self.process_michinoeki_page(doc, page.url)

        elsif title.match(/GeoHack - (道の駅.+)/)

          self.process_geohack_page(doc)

        end
      end
    end
  end

  def self.focus_michinoeki_page(doc, url)
    nodes = doc.xpath('//*[@id="mw-content-text"]/table/tr/td[1]/a')
    nodes = nodes.select do |node|
      is_valid_url = node.attribute('href').to_s.match(/\/wiki\/.*/)
      is_valid_title = node.attribute('title').to_s.match(/道の駅.*/)
      is_valid_url && is_valid_title
    end
    links = nodes.map do |node|
      URI.parse(url.scheme + '://' + url.host + node.attribute('href'))
    end
    links[0..7]
  end

  def self.focus_geohack_page(doc)
    url = doc.css('a.external.text').attribute('href')
    [URI.parse("https:#{url}")]
  end

  def self.process_michinoeki_page(doc, url)
    title = doc.at('title').inner_html.to_s
    puts title
    matches = title.match(/(道の駅.+) - W+/)
    wiki = WikipediaPage.where('title LIKE ?', "%#{matches[1]}%").first
    unless wiki
      wiki = WikipediaPage.new
    end

    wiki.title = title
    wiki.url = url.to_s
    puts "#{wiki.title} #{wiki.url}"

    html = doc.xpath('//*[@id="mw-content-text"]/table[1]/tr[1]/th').to_s
    html.gsub!(/(\s)/, '')

    if html.match(/.+<br>.+/)
      html = Sanitize.fragment(html, :elements => ['br'])
      names = html.split('<br>')
      wiki.name = names[0].strip
      if names.length > 1
        wiki.phrase = names[1].strip
      end
    else
      wiki.name = Sanitize.fragment(html)
    end

    if wiki.name == ''
      matches = wiki.title.match(/道の駅([^ ]+) -.*/)
      puts "No name retrieved, so filled with title #{wiki.title}"
      if matches.length > 1
        wiki.name = matches[1]
      end
    end

    address = Sanitize.fragment(self.identify_address_fragment(doc))
    address.gsub!(/(\s)/, '')
    matches = address.match(/(〒[0-9]+-[0-9]+)([^0-9]+.+)/)
    if matches && matches.length > 2
      wiki.zip_code = matches[1]
      wiki.address = matches[2]
    else
      wiki.address = address
    end

    description = doc.xpath('//*[@id="mw-content-text"]')
    description.search('.infobox').remove
    description.search('#toc').remove
    description.search('.mbox-small').remove
    description.search('.mw-editsection').remove
    description.search('.asbox').remove
    wiki.description = description.to_s

    wiki.save
  end

  def self.process_geohack_page(doc)
    title = doc.at('title').inner_html.to_s
    matches = title.match(/GeoHack - (道の駅.+)/)
    wiki = WikipediaPage.where('title LIKE ?', "%#{matches[1]}%").first

    wiki.longitude = doc.css('.geo > .longitude').inner_html.to_s
    wiki.latitude = doc.css('.geo > .latitude').inner_html.to_s

    wiki.save
  end

  def self.identify_address_fragment(doc)
    nodes = doc.css('table.infobox > tr')
    nodes = nodes.select do |node|
      node.search('td').to_s.match(/〒/)
    end
    nodes.first
  end

end
