# frozen_string_literal: true

class ChaatsController < ApplicationController
  before_action :authenticate_account!


  def index
    @chaat = current_account.chaats.build if account_signed_in?
    @feed_items = Chaat.includes(:account).paginate(page: params[:page])
    render 'static_pages/home'
  end

  def create
    @chaat = current_account.chaats.build(chaat_params)
    if @chaat.save
      flash[:success] = 'Chaat created!'
      redirect_to root_url
    else
      flash[:danger] = @chaat.errors.full_messages.to_sentence
      redirect_to root_url
    end
  end

  def destroy
    @chaat.destroy
    redirect_to root_url
  end

  private
    def chaat_params
      params.require(:chaat).permit(:chaat_body)
    end

    def correct_account
      @chaat = current_account.chaats.find_by(id: params[:id])
      redirect_to root_url if @chaat.nil?
    end
end
