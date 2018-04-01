module Adjudication
  module TestUtils
    def self.build_claim_data
      JSON.parse('{
        "provider": "1811052616",
        "number": "2017-09-01-123214",
        "start_date": "2017-09-01",
        "subscriber": {
          "ssn": "000-11-7777",
          "group_number": "US00123"
        },
        "patient": {
          "ssn": "000-12-5555",
          "relationship": "spouse"
        },
        "line_items": [
          {
            "procedure_code": "D1110",
            "tooth_code": null,
            "charged": 47
          },
          {
            "procedure_code": "D0120",
            "tooth_code": null,
            "charged": 25
          }
        ]
      }')
    end

    def self.build_claim_line_item_data(procedure_code = "D1110", tooth_code = "null", charged = 47)
      JSON.parse("{
            \"procedure_code\": \"#{procedure_code}\",
            \"tooth_code\": #{if tooth_code then tooth_code else "null" end},
            \"charged\": #{charged}
          }")
    end
  end
end