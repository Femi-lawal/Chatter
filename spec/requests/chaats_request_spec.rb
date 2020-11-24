# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Chaats", type: :request do
  describe "in the Chaats controller" do
    describe "#index" do
      before { get chaats_path }
      it { expect(response.status).to eq(200) }
    end

    describe "#create" do
      before { post chaats_path }
      it { expect(response).to redirect_to(new_account_session_path) }
    end

    describe "#destroy" do
      before { delete chaat_path(1) }
      it { expect(response).to redirect_to(new_account_session_path) }
    end
  end
end
