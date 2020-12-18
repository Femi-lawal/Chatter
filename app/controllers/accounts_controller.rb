# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_account

  # GET /accounts
  def index
    @accounts = Account.all
  end

  # GET /accounts/1
  def show
    @chaat = current_account.chaats.build if account_signed_in?
    @feed_items = @account.chaats.paginate(page: params[:page])
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      flash[:success] = 'Update your profile'
      redirect_to @account
    else
      render :edit
    end
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy
    redirect_to root_url
  end

  def following
    @title = 'Following'
    @accounts = @account.following.paginate(page: params[:page])
    render :show_follow
  end

  def followers
    @title = 'Followers'
    @accounts = @account.followers.paginate(page: params[:page])
    render :show_follow
  end

  private
    def set_account
      @account = Account.find_by(account_name: params[:id])
    end

    def account_params
      params.require(:account).permit(:name, :email, :password, :password_confirmation, :account_name)
    end

    def correct_account
      redirect_to(new_account_session_path) unless current_account?(@account)
    end
end
