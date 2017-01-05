class Config

	def initialize( host: "shopicruit.myshopify.com", access_token: "c32313df0d0ef512ca64d5b336a0d7c6")
		@host = host
		@access_token = access_token
	end

	attr_reader :host,
				:access_token

end