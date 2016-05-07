require 'kconv'
require 'pp'

require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'

require 'selenium-webdriver'

# DRIVER = :selenium
DRIVER = :poltergeist

Capybara.configure do |config|
  config.run_server = false
  config.current_driver = DRIVER
  config.javascript_driver = DRIVER
  config.app_host = 'http://www.day-onsen.com/'
  config.default_max_wait_time = 5
  config.default_selector = :xpath
  config.ignore_hidden_elements = false
end

if DRIVER === :poltergeist
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, {:timeout => 120, :js_errors => false})
  end
end

module Tasks
  class BathDayOnsen

    include Capybara::DSL

    def self.crawl

      michinoekis = MichinoekiWikipediaPage.all()
      michinoekis = michinoekis[0..2]
      michinoekis.each_slice(2) do |five_michinoekis|
        michinoeki_names = five_michinoekis.map do |michinoeki|
          michinoeki.name
        end
        puts michinoeki_names
        self.crawl_by_michinoeki_names(michinoeki_names)
      end
    end

    def self.crawl_by_michinoeki_names(michinoeki_names)
      urls = michinoeki_names.map do |michinoeki_name|
        self.fetch_bath_urls("#{michinoeki_name}")
      end
      puts urls
      urls.flatten!
      urls.uniq!

      options = {
          :delay => 5,
          :depth_limit => 0
      }

      Anemone.crawl(urls, options) do |anemone|

        puts 'Anemone crawl'

        # Scraping HTML
        anemone.on_every_page do |page|
          doc = Nokogiri::HTML.parse(page.body.toutf8)
          self.process_day_onsen_page(doc, page.url)
        end

      end
    end

    def self.process_day_onsen_page(doc, url)

      title = doc.at('title').inner_html.to_s.strip
      onsen = BathDayOnsenPage.where('url = ?', url).first
      unless onsen
        onsen = BathDayOnsenPage.new
      end

      onsen.title = title
      onsen.url = url.to_s
      puts "#{onsen.title} #{onsen.url}"

      onsen.name = doc.xpath('//*[@id="ctl00_PH_usr_sisetuhead_h施設名"]').text

      if onsen.name == ''
        matches = onsen.title.match(/(.+)（.+/)
        puts "No name retrieved, so filled with title #{onsen.title}"
        if matches.length > 1
          onsen.name = matches[1]
        end
      end

      onsen.description = doc.xpath('//*[@id="ctl00_PH_lblPR"]').text
      onsen.category = doc.xpath('//*[@id="ctl00_PH_usr_sisetuhead_lbl種類"]').text
      onsen.tel = doc.xpath('//*[@id="ctl00_PH_usr_sisetuhead_lbl住所"]/strong').text
      address = doc.xpath('//*[@id="ctl00_PH_usr_sisetuhead_lbl住所"]')
      address.search('.strong_nor').remove
      onsen.address = Sanitize.fragment(address.text)

      nodes = doc.css('.kodawari')
      points = nodes.map do |node|
        node.text
      end
      onsen.points = points.join(',')

      onsen.price = doc.xpath('//*[@id="ctl00_PH_divall"]/table/tbody/tr/td[2]/div[3]/div[3]/table[2]/tbody/tr[1]/td[2]').text
      onsen.open = doc.xpath('//*[@id="ctl00_PH_lbl営業時間"]').text
      onsen.holiday = doc.xpath('//*[@id="ctl00_PH_lbl定休日"]').text
      onsen.parking = doc.xpath('//*[@id="ctl00_PH_lbl駐車場"]').text
      onsen.homepage_url = doc.xpath('//*[@id="ctl00_PH_hlnkurl"]').text

      onsen.bath_indoor = doc.xpath('//*[@id="ctl00_PH_lbl内風呂"]').text
      onsen.bath_outdoor = doc.xpath('//*[@id="ctl00_PH_lbl露天風呂"]').text
      onsen.bath_private = doc.xpath('//*[@id="ctl00_PH_lbl貸切風呂"]').text
      onsen.bath_varieties = doc.xpath('//*[@id="ctl00_PH_lbl風呂種類"]').text
      onsen.bath_remarks = doc.xpath('//*[@id="ctl00_PH_lbl風呂その他"]').text

      onsen.facilities_rest_public = doc.xpath('//*[@id="ctl00_PH_lbl休憩所"]').text
      onsen.facilities_rest_personal = doc.xpath('//*[@id="ctl00_PH_lbl個室休憩所"]').text
      onsen.facilities_restaurant = doc.xpath('//*[@id="ctl00_PH_lbl食事処"]').text
      onsen.facilities_massage = doc.xpath('//*[@id="ctl00_PH_lblマッサージ"]').text
      onsen.facilities_treatment = doc.xpath('//*[@id="ctl00_PH_lblエステ"]').text
      onsen.facilities_remarks = doc.xpath('//*[@id="ctl00_PH_lbl施設その他"]').text
      onsen.facilities_supply = doc.xpath('//*[@id="ctl00_PH_lbl手ぶら"]').text
      onsen.facilities_stay = doc.xpath('//*[@id="ctl00_PH_lbl宿泊"]').text

      onsen.spa_spot = doc.xpath('//*[@id="ctl00_PH_lbl温泉地名"]').text
      onsen.spa_quality = doc.xpath('//*[@id="ctl00_PH_lbl源泉"]').text
      onsen.spa_varieties = doc.xpath('//*[@id="ctl00_PH_lbl泉質"]').text
      onsen.spa_remarks = doc.xpath('//*[@id="ctl00_PH_lbl効能"]').text
      onsen.neighborhood = doc.xpath('//*[@id="ctl00_PH_lbl近隣"]').text

      onsen.save

    end

    def self.fetch_bath_urls(michinoeki_name)

      puts "Search bath by #{michinoeki_name}"

      links = []
      session = Capybara::Session.new(DRIVER)
      if DRIVER === :poltergeist
        session.driver.headers = {'User-Agent' => 'Mac Safari'}
      end

      session.visit('')
      session.fill_in 'ctl00$PH$txt住所', :with => michinoeki_name
      # Poltergeist lose some necessary elements and scripts in html, so add by JavaScript..
      session.execute_script %Q`
      theForm = document.forms['aspnetForm'];
      if (!theForm) {
          theForm = document.aspnetForm;
      }
      var eventTarget = document.createElement('input');
      eventTarget.type = 'hidden';
      eventTarget.name = '__EVENTTARGET';
      eventTarget.id = '__EVENTTARGET';
      eventTarget.value = '';
      theForm.appendChild(eventTarget);

      function __doPostBack(eventTarget, eventArgument) {
          if (!theForm.onsubmit || (theForm.onsubmit() != false)) {
              document.getElementById('__EVENTTARGET').value = eventTarget;
              theForm.submit();
          }
      }

      var gc = new google.maps.Geocoder();
      gc.geocode({ address : '#{michinoeki_name}' }, function(results, status){
        if (status == google.maps.GeocoderStatus.OK) {
            document.getElementById("ctl00_PH_hidmapgeo").value = results[0].geometry.location.lat() + ":" + results[0].geometry.location.lng() + ":2";
            __doPostBack('ctl00$PH$btnAD','');
        }
      });
      `
      # session.find(:css, '#ctl00_PH_txt住所').send_keys :enter
      sleep 5 # wait for response

      # session.save_screenshot("#{DRIVER}.png", :full => true)

      puts session.current_url
      doc = Nokogiri::HTML.parse(session.html)
      nodes = doc.css('.mapinfoarea')
      nodes.each do |node|
        links.push('http://www.day-onsen.com' + (node.search('.strong_nor a').attribute('href')))
      end
      links
    end

  end
end

# Tasks::BathDayOnsen.fetch_bath_urls('道の駅アグリパークゆめすぎと')