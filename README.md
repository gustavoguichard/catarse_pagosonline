# CatarsePagosonline

Pagosonline integration with [Catarse](http://github.com/catarse/catarse) crowdfunding platform

## Installation

Add this lines to your Catarse application's Gemfile:

    gem 'pagosonline', git: 'git://github.com/sagmor/pagosonline.git'
    gem 'catarse_pagosonline'

And then execute:

    $ bundle

## Usage

Configure the routes for your Catarse application. Add the following lines in the routes file (config/routes.rb):

    mount CatarsePagosonline::Engine => "/", :as => "catarse_pagosonline"

### Configurations

Create this configurations into Catarse database:

    pagosonline_merchant, pagosonline_ipn_password and pagosonline_country_id

In Rails console, run this:

    Configuration.create!(name: "pagosonline_merchant", value: "123456")
    Configuration.create!(name: "pagosonline_country_id", value: "2")
    Configuration.create!(name: "pagosonline_ipn_password", value: "ipn_password")
    Configuration.create!(name: "pagosonline_currency", value: "clp")

  Currencies:
    "ars"
    "mxn"
    "clp"
    "brl"
    "usd"

## Development environment setup

Clone the repository:

    $ git clone git://github.com/gustavoguichard/catarse_pagosonline.git

Add the catarse code into test/dummy:

    $ git submodule add git://github.com/catarse_pagosonline/catarse.git test/dummy

Copy the Catarse's gems to Gemfile:

    $ cat test/dummy/Gemfile >> Gemfile

And then execute:

    $ bundle

Replace the content of test/dummy/config/boot.rb by this:

    require 'rubygems'
    gemfile = File.expand_path('../../../../Gemfile', __FILE__)
    if File.exist?(gemfile)
      ENV['BUNDLE_GEMFILE'] = gemfile
      require 'bundler'
      Bundler.setup
    end
    YAML::ENGINE.yamler= 'syck' if defined?(YAML::ENGINE)

    $:.unshift File.expand_path('../../../../lib', __FILE__)


## Troubleshooting in development environment

Remove the admin folder from test/dummy application to prevent a weird active admin bug:

    $ rm -rf test/dummy/app/admin

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


This project rocks and uses MIT-LICENSE.
