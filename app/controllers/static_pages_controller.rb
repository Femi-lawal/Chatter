# frozen_string_literal: true

class StaticPagesController < ApplicationController
  before_action :authenticate_account!

  def home
    if account_signed_in?
      @feed_items = current_account.feed.includes(:account).paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
