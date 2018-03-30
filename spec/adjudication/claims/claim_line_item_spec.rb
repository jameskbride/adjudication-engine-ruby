require "spec_helper"

RSpec.describe Adjudication::Claims::ClaimLineItem do

  context "Rejected status" do

    let(:claim_line_item_data) {Adjudication::TestUtils.build_claim_line_item_data}
    let(:claim_line_item) {Adjudication::Claims::ClaimLineItem.new(claim_line_item_data)}

    it "it is not rejected by default" do
      expect(claim_line_item.is_rejected?).to eq(false)
    end

    it "it can be rejected" do
      claim_line_item.reject!

      expect(claim_line_item.is_rejected?).to eq(true)
    end
  end
end