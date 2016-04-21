module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end
  end

	module HeaderHelpers
	  extend RSpec::SharedContext

	  let(:headers) do
	    {
				'Accept': 'application/json; version=1',
				'Content-Type': 'application/json'
			}
	  end
	end
end
