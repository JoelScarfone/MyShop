require 'net/http'
require 'json'
require_relative 'config'

class ShopifyApiConnector

	def initialize(config)
		raise ArgumentError.new("Required class type 'Config' - recieved #{config.class}") unless config.kind_of? Config
		@config = config 
	end

	def get_orders
		num_orders = get_num_orders
		orders = nil
		page_num = 1
		while orders.nil? or orders.count < num_orders
			uri = URI("https://#{@config.host}/admin/orders.json?page=#{page_num}&access_token=#{@config.access_token}")
			Net::HTTP.start(uri.host, uri.port,
				:use_ssl => uri.scheme == 'https') do |http|
				request = Net::HTTP::Get.new uri

				response = http.request request # Net::HTTPResponse object
				response_json = JSON.parse(response.body)
				orders.nil? ? orders = response_json["orders"] : orders = orders + response_json["orders"]
			end
			page_num += 1
		end
		return orders
	end

	def get_num_orders
		uri = URI("https://#{@config.host}/admin/orders/count.json?access_token=#{@config.access_token}")
		Net::HTTP.start(uri.host, uri.port,
			:use_ssl => uri.scheme == 'https') do |http|
			request = Net::HTTP::Get.new uri

			response = http.request request # Net::HTTPResponse object
			return JSON.parse(response.body)["count"]
		end
		return nil
	end

end
