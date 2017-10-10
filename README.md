# HeatmapRb :construction:

Integrate heatmaps in your web application to see on which part the user spends most time on your web application. Where does users click on the page.
Helping in gathering analytics to find out what works on the web, what attracts most of the users.
View user interactions and make your application more amazing! :sparkles:

## Local Testing

Use

```ruby
gem 'heatmap-rails', git: 'https://github.com/Qbatch/heatmap-rails.git'
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'heatmap_rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install heatmap_rb

## Usage

1. Install the gem
2. Run the command to generate migration:
```console
$ rails g heatmap_rb:install
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

6. In respective JS file, Require HeatMap.Js to show the heatmap:
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

Another way can be using some code in URL. For example is you want to use URL like

```url
www.website.com/see_heatmap
```

You can use:

```erb
<% if request.path.include?("see_heatmap") %>
    <%= show_heatmap(request.path) %>
<% end %>
```

And there can be multiple ways!
### Options

You can customize:
```erb
<%= save_heatmap({click: 3, move: 50}) %>
```
These are default values.

## Development :construction:

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Credits
heatmap-rails uses [HeatMap.Js](https://www.patrick-wied.at/static/heatmapjs/) to generated show heatmaps.

## Contributing :construction:

1. [Bug reports](https://github.com/Qbatch/heatmap-rails/issues) are always welcome.
2. [Pull Requests](https://github.com/Qbatch/heatmap-rails/pulls). Suggest or Update.

## License :construction:

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
