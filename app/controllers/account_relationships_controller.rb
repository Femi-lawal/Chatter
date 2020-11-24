# frozen_string_literal: true

class AccountRelationshipsController < ApplicationController
  before_action :authenticate_account!

  def create
    @account = Account.find(params[:account_relationship][:followed_id])
    current_account.follow!(@account)
    redirect_to @account
  end

  def destroy
    @account = AccountRelationship.find(params[:id]).followed
    current_account.unfollow!(@account)
    redirect_to @account
  end
end
