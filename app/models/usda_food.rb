
class UsdaFood < Food

	def self.usda_search( term, args = {} )
		params = {
			format: :json,
			lt: :f, #food
			sort: :n, # name
			max: 25,
			offset: 0,
			api_key: 'DEMO_KEY',
		}.merge(args[:params] || {}).merge({ q: term })
		json = RestClient.get("https://api.nal.usda.gov/ndb/search/?#{params.to_query}")
		response = JSON.parse( json, :symbolize_names => true )

		response[:list][:item].collect do |item|
			UsdaFood.create_with( title: item[:name], properties: item.merge( 'status' => 'search' ) ).find_or_initialize_by( usda_ndbno: item[:ndbno] )
		end

	end

	def fetch_details!( args = {} )
		force_fetch_details! if self.properties['status'] == 'search'
	end

	def force_fetch_details!( args = {} )

		params = {
			format: :json,
			type: :f,
			ndbno: self.usda_ndbno,
			api_key: 'DEMO_KEY',
		}

		json = RestClient.get("https://api.nal.usda.gov/ndb/reports/?#{params.to_query}")
		response = JSON.parse( json, :symbolize_names => true )

		self.properties = self.properties.merge( 'status' => 'detailed', 'details' => response[:report][:food].to_json )
		self.save

		response[:report][:food]
	end

end
