[![Gem Version](https://badge.fury.io/rb/heatmap-rails.svg)](https://badge.fury.io/rb/heatmap-rails)

# Heatmap-Rails

Integrate heatmaps in your web application to see on which part the user spends most time on your web application. Where does users click on the page.
Helping in gathering analytics to find out what works on the web, what attracts most of the users.
View user interactions and make your application more amazing! :sparkles:

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heatmap-rails'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heatmap-rails

## Usage

1. Install the gem

2. Run the command to generate a migration to save heatmaps data:
```console
$ rails g heatmap_rails:install
```

3. Migrate:
```console
$ rake db:migrate
```

4. Include the following helper on any page where you need to generate the heatmap:
```erb
<%= save_heatmap %>
```

5. Include where to show the heatmap:
```erb
<%= show_heatmap(request.path) %>
```
6. Before adding headmap.js in the application install **jquery-rails** gem and require it in application.js file
```js
//= require jquery
```


7. In respective JS file, Require HeatMap.Js to show the heatmap:
```js
//= require heatmap.js
```
## Viewing Heat Maps
Use the helper
```erb
<%= show_heatmap(request.path) %>
```
The argument is the path of current page. This way the helper will only display the respective heatmap.
The viewing can be done in multiple ways, for example if you want only the admin users to view heatmap, you can do something like:

```erb
<% if admin_user_signed_in? %>
    <%= show_heatmap(request.path) %>
<% end %>
```

Another way can be using some param in the URL. For example if you want to use URL like:

```url
www.website.com/see_heatmap
```

You can use:

```erb
<% if request.path.include?("see_heatmap") %>
    <%= show_heatmap(request.path) %>
<% end %>
```

### Options

You can customize the max stack limits before the data is sent to server side via http request. We understand for different application the average user interactions time on a specific page varies. You can set these values w.r.t to your application's needs:
```erb
<%= save_heatmap({click: 3, move: 50}) %>
```
The default values for clicks is `3`. For mouse movements tracking its `50`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Credits
heatmap-rails uses [HeatMap.Js](https://www.patrick-wied.at/static/heatmapjs/) to show generated data in form of heatmaps.

## Contributing :construction:

1. [Bug reports](https://github.com/Qbatch/heatmap-rails/issues) are always welcome.
2. [Pull Requests](https://github.com/Qbatch/heatmap-rails/pulls). Suggest or Update.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
