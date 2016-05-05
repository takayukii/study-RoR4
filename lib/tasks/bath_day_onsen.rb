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

      urls = self.fetch_bath_urls('道の駅アグリパークゆめすぎと')
      options = {
          :delay => 1,
          :depth_limit => 0
      }
      puts urls

      Anemone.crawl(urls, options) do |anemone|

        # Scraping HTML
        anemone.on_every_page do |page|

          doc = Nokogiri::HTML.parse(page.body.toutf8)
          title = doc.at('title').inner_html.to_s
          puts "process #{title}"
        end
      end
    end

    def self.fetch_bath_urls(michinoeki_name)

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
