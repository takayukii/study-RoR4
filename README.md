# study Ruby on Rails 4

## rails new

[rails new 手順書](http://qiita.com/youcune/items/312178c54c65f3ab4d42)

```
$ mkdir crawler
$ cd crawler
$ bundle init
```

`Gemfile`

```
# A sample Gemfile
source "https://rubygems.org"

gem "rails"
```

```
$ bundle install --path vendor/bundler --jobs=4
$ bundle exec rails new . --database=mysql
```

## database.yml

Edit `config/database.yml`

```
default: &default
  adapter: mysql2
  encoding: utf8
  pool: 5
  username: rubydev
  password: rubydev
  host: 127.0.0.1

development:
  <<: *default
  database: rubydev
```

## rails server

```
# Vagrantfile
config.vm.synced_folder './', '/share', :nfs => true
```

```
$ bundle exec rails s -b 0.0.0.0
```

## rails generate controller

```
$ rails generate controller home
```

generates controller, view, test, coffee, scss..

## rake db:migrate

```
$ rails generate migration create_wikipedia_pages // NOTE: generate model automatically creates migration!
```

```
$ rake db:migrate
```

```
$ rake db:rollback
```

[create_table - Railsドキュメント](http://railsdoc.com/references/create_table)

## rails generate model

```
$ rails generate model wikipedia_page
```

generates migration, model, test, fixtures

```
$ rails console
```

```
2.1.0 :001 > WikipediaPage.all
  WikipediaPage Load (0.3ms)  SELECT `wikipedia_pages`.* FROM `wikipedia_pages`
 => #<ActiveRecord::Relation []> 
2.1.0 :002 > page = WikipediaPage.new
 => #<WikipediaPage id: nil, title: nil, url: nil, body: nil, station_name: nil, address: nil, created_at: nil, updated_at: nil> 
2.1.0 :003 > page.title = 'test1'
 => "test1" 
2.1.0 :004 > page.url = 'http://test1.com'
 => "http://test1.com" 
2.1.0 :005 > page.body = '<h1>body..</h1>'
 => "<h1>body..</h1>" 
2.1.0 :006 > page.save
   (0.2ms)  BEGIN
  SQL (0.9ms)  INSERT INTO `wikipedia_pages` (`title`, `url`, `body`, `created_at`, `updated_at`) VALUES ('test1', 'http://test1.com', '<h1>body..</h1>', '2016-04-30 15:18:35', '2016-04-30 15:18:35')
   (3.8ms)  COMMIT
 => true 
2.1.0 :009 > page.id
 => 1 
2.1.0 :007 > WikipediaPage.all
  WikipediaPage Load (0.6ms)  SELECT `wikipedia_pages`.* FROM `wikipedia_pages`
 => #<ActiveRecord::Relation [#<WikipediaPage id: 1, title: "test1", url: "http://test1.com", body: "<h1>body..</h1>", station_name: nil, address: nil, created_at: "2016-04-30 15:18:35", updated_at: "2016-04-30 15:18:35">]> 
2.1.0 :008 > WikipediaPage.find(1)
  WikipediaPage Load (0.4ms)  SELECT  `wikipedia_pages`.* FROM `wikipedia_pages` WHERE `wikipedia_pages`.`id` = 1 LIMIT 1
 => #<WikipediaPage id: 1, title: "test1", url: "http://test1.com", body: "<h1>body..</h1>", station_name: nil, address: nil, created_at: "2016-04-30 15:18:35", updated_at: "2016-04-30 15:18:35"> 
```

## rails runner

[Rails コピペで作れるバッチファイル](http://qiita.com/Kaki_Shoichi/items/9f641bc030991c94d5e7)

