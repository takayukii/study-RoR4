# study Ruby on Rails 4

## rails new

[rails new 手順書](http://qiita.com/youcune/items/312178c54c65f3ab4d42)

```
$ mkdir project
$ cd project
$ bundle init
```

Edit `Gemfile`

```
# A sample Gemfile
source "https://rubygems.org"

gem "rails"
```

Install rails

```
$ bundle install --path vendor/bundle --jobs=4
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

Rails is very slow, unless Vagrant scynced_folder has been configured with NFS..

```
# Vagrantfile
config.vm.synced_folder './', '/share', :nfs => true
```

```
$ bundle exec rails s -b 0.0.0.0
```

## rails generate scaffold

You should `rails g scaffold xxx` with database columns (e.g. name:string price:integer) if you want to create CRUD. Without columns, generated views are all empty.  

```
$ rails g scaffold item name:string price:integer
```

Able to use --force option if files already existing

## rails generate controller

```
$ rails generate controller home
```

generates controller, view, test, coffee, scss.. Note it includes view related files too.

## rails generate model

```
$ rails generate model wikipedia_page
```

generates migration, model, test, fixtures

You can operate your Model interactively via console.

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

## rails runner

[Rails コピペで作れるバッチファイル](http://qiita.com/Kaki_Shoichi/items/9f641bc030991c94d5e7)

```
$ rails runner Tasks::ATask.execute
```

## Remote Debug with IDEA

Gems required

```
gem 'ruby-debug-ide'
gem 'debase'
```

Firstly, run rails server with command below. Note that debug session in IDEA has stopped.

```
$ rdebug-ide --host 0.0.0.0 --port 1234 --dispatcher-port 26162 -- bin/rails s -b 0.0.0.0
```

Then press debug button in IDEA to start debug session.

## Geocoder 

Very useful gem which is well integrated with Rails.

https://github.com/alexreisner/geocoder

After gem install and `rails g geocoder:config`, you can configure parameters in `config/initializers/geocoder.rb`

```
$ rails generate geocoder:config
```

In Model, 

```
class AModel < ActiveRecord::Base
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?
end
```

Also, you can execute batch geocode

```
$  rake geocode:all CLASS=AModel
```

## Debug Toolbar / Rails Panel

[Rails 開発をサポートするChrome拡張 Rails Panel の機能と仕組み](http://blog.chopschips.net/blog/2015/03/06/rails-panel/)

## link_to

[Rails でリンクパスを生成する方法色々・・とRails console で 生成される path を確認したい時](http://qiita.com/mm36/items/f266977e12df9d1dc548)

Check path name

```
$ rake routes
```

link_to {Prefix}_path would work in views
