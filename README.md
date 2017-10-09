# HeatmapRb

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/heatmap_rb`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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
2. Run:

    $ rails g heatmap_rb:install

3. Migrate:

    $ rake db:migrate

4. Include the following helper on any page where you need to generate the heatmap:

    <%= save_heatmap %>

5. You can customize:

    <%= save_heatmap({click: 3, move: 50}) %>

6. Include where to show the heatmap:

    <%= show_heatmap(request.path) %>

7. Require HeatMap.Js:

    require heatmap.js

These are default values.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/heatmap_rb.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
