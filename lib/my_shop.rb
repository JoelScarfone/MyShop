#!/usr/bin/env ruby
require 'optparse'
require_relative 'shopify_api_connector' 
require_relative 'config' 

CALCULATE_REVENUE = 1

options = { :do_throughput_measurement => false, :query_string => '', :debug => false }

OptionParser.new do|opts|
	opts.banner = "Usage: myshop [options] \nDefault paramaters aim to complete shopify's 2017 summer internship task."

	opts.on('-t', '--host host', 'Host or domain name where your shop is.') do |host|
		options[:host] = host
	end

	opts.on('-a', '--access-token access_token', 'Specify the acces token used when connecting to the Shopify API.') do |access_token|
		options[:access_token] = access_token
	end

	opts.on('-c', '--calculate-revenu', 'Mode of operation (Default)') do 
		options[:mode] = CALCULATE_REVENUE
	end

	opts.on('-h', '--help', 'Displays help') do
		puts "\n#{opts}"
		puts
		exit
	end

end.parse!

options[:host] = "shopicruit.myshopify.com" if options[:host].nil?
options[:access_token] = "c32313df0d0ef512ca64d5b336a0d7c6" if options[:access_token].nil?

config = Config.new(host: options[:host], access_token: options[:access_token])
api_connector = ShopifyApiConnector.new(config)

orders = api_connector.get_orders

options[:mode] = CALCULATE_REVENUE if options[:mode].nil?

case options[:mode]
when CALCULATE_REVENUE
	total_revenue = 0.0
	orders.each do |order|
		total_revenue += order["total_price"].to_f
	end
	puts "Total Revenue: #{total_revenue.round(2)}"
end