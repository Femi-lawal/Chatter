# frozen_string_literal: true

require "rails_helper"

RSpec.describe "AccountRelationships", type: :request do
  describe "in the AccountRelationships controller" do
    describe "submitting to the create action" do
      before { post account_relationships_path }
      it { expect(response).to redirect_to(new_account_session_path) }
    end

    describe "submitting to the destroy action" do
      before { delete relationship_path(1) }
      it { expect(response).to redirect_to(new_account_session_path) }
    end
  end
end
