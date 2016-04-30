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

## rails server
 
 ```
 $ bundle exec rails s -b 0.0.0.0
 ```
 

