# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper, type: :helper do
  it { expect(full_title("title")).to eq "title | Chatter " }
  it { expect(full_title("")).to eq "Chatter " }
end
