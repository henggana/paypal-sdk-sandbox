# Paypal Exception: 
# PayPal::SDK::Core::Exceptions::ResourceNotFound

require 'paypal-sdk-rest'
class PaymentsController < ApplicationController
  include PayPal::SDK::REST

  before_action :authenticate_user
  before_action :config_paypal_sdk, only: [:index, :show, :paypal, :credit_card,
                                           :paypal_return, :paypal_cancel]

  def index
    @payments = Payment.all
  end

  def show
    # Fetch Payment
    @payment = Payment.find(params[:id]) if params[:id].present?
    @payments = Payment.all
    binding.pry if @payment || @payments
  end

  def credit_card
    @payment = Payment.new(fake_credit_card_transaction)

    # Create Payment and return the status(true or false)
    if @payment.create
      flash[:success] = @payment.id
      @payment.id     # Payment Id
      redirect_to payments_path
    else
      binding.pry
      @payment.error  # Error Hash
    end
  end

  def paypal
    @payment = Payment.new(fake_paypal_transaction)

    # Create Payment and return the status(true or false)
    if @payment.create
      link = @payment.links.find {|link| link.rel == 'approval_url' }.try(:href)
      binding.pry
      flash[:success] = "#{@payment.id} - #{link}"
      @payment.id     # Payment Id
      redirect_to payments_path
    else
      binding.pry
      @payment.error  # Error Hash
    end
  end

  def paypal_return
    binding.pry
    if params[:paymentId] && params[:PayerID]
      payment = Payment.find(params[:paymentId])
      payment.execute(payer_id: params[:PayerID])
    end
    flash[:success] = "payment executed!"
    redirect_to payments_path
  end

  def paypal_cancel
    binding.pry
    flash[:success] = "payment canceled!"
    redirect_to payments_path
  end

  protected

  def config_paypal_sdk
    PayPal::SDK::REST.set_config(
      :mode => "sandbox", # "sandbox" or "live"
      # :client_id => "AfX64yhRoywezWIqPNd5hzbXJ7E0fsysri8OQm4Xx2GEDdWkDAVrP56Riqy-0GeAQWy-uEcDecgMgOS1",
      # :client_secret => "EAw3QADRC24Qo6PqTR_xKeJYVeOuTe2lInnPK4XyrtvzI5GunE1dEJqvXbk5r-9yPE01rrRm3EAD0SL-")
      :client_id => session[:user]['client_id'],
      :client_secret => session[:user]['secret'])
  end

  def fake_credit_card_transaction
    {
      :intent => "sale",
      :payer => {
        :payment_method => "credit_card",
        :funding_instruments => [{
          :credit_card => {
            :type => "visa",
            :number => "4567516310777851",
            :expire_month => "11",
            :expire_year => "2018",
            :cvv2 => "874",
            :first_name => "Joe",
            :last_name => "Shopper",
            :billing_address => {
              :line1 => "52 N Main ST",
              :city => "Johnstown",
              :state => "OH",
              :postal_code => "43210",
              :country_code => "US" }}}]},
      :transactions => [{
        :item_list => {
          :items => [{
            :name => "item",
            :sku => "item",
            :price => "1",
            :currency => "USD",
            :quantity => 1 }]},
        :amount => {
          :total => "1.00",
          :currency => "USD" },
        :description => "This is the payment transaction description." }]}
  end

  def fake_paypal_transaction
    {
      :intent => "sale",
      "redirect_urls":{
        "return_url":"http://localhost:3000/payments/paypal_return",
        "cancel_url":"http://localhost:3000/payments/paypal_cancel" },
      :payer => {
        :payment_method => "paypal" },
      :transactions => [{
        :item_list => {
          :items => [{
            :name => "item",
            :sku => "item",
            :price => "1",
            :currency => "USD",
            :quantity => 1 }]},
        :amount => {
          :total => "1.00",
          :currency => "USD" },
        :description => "This is the payment transaction description." }]}
  end
end