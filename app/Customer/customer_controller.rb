require 'rho/rhocontroller'
require 'helpers/browser_helper'

class CustomerController < Rho::RhoController
  include BrowserHelper

  def map_it
    puts "## Inside map_it, params: #{@params.inspect}"
    @customer = Customer.find(@params["id"])

    puts "## Lat: #{@customer.lat} -- Long: #{@customer.long}"

    if @customer.lat.to_i == 0
      @customer.lat = '37.349691'
    end

    if @customer.long.to_i == 0
      @customer.long = '-121.983261'
    end

    map_params = {
                    :settings => {
                          :map_type => "roadmap",
                          # region specifies where the map is centered (lat, long) and
                          # how large (in degrees) the map should be
                          :region => [@customer.lat, @customer.long, 0.2, 0.2],
                          # Should user be able to zoom
                          :zoom_enabled => true,
                          # Should user be able to scroll
                          :scroll_enabled => true,
                          # Default show user location
                          :shows_user_location => false,
                          # Not needed for Simulator/Emulator
                          :api_key => '0ouTrGxGzENd8jK-uPlbbTMNB2vuROCFBr4y5ug'
                        },
                    :annotations => [{
                                      :latitude => @customer.lat,
                                      :longitude => @customer.long,
                                      # The text that shows up when the
                                      # pin is clicked
                                      :title => "#{@customer.first} #{@customer.last}",
                                      :subtitle => "Go to Customer",
                                      # when the user clicks on this,
                                      # show the customer
                                      :url => "/app/Customer/{#{@customer.object}}"
                                    }]

                }

    puts "### map_params: #{map_params.inspect}"
    puts "### MapView: #{MapView.inspect}"

    MapView.create map_params

    # URL to go to when the map is closed
    redirect :action => :index

  end

  # GET /Customer
  def index
    @customers = Customer.find(:all)
    render :back => '/app'
  end

  # GET /Customer/{1}
  def show
    @customer = Customer.find(@params['id'])
    if @customer
      render :action => :show, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # GET /Customer/new
  def new
    @customer = Customer.new
    render :action => :new, :back => url_for(:action => :index)
  end

  # GET /Customer/{1}/edit
  def edit
    @customer = Customer.find(@params['id'])
    if @customer
      render :action => :edit, :back => url_for(:action => :index)
    else
      redirect :action => :index
    end
  end

  # POST /Customer/create
  def create
    @customer = Customer.create(@params['customer'])
    redirect :action => :index
  end

  # POST /Customer/{1}/update
  def update
    @customer = Customer.find(@params['id'])
    @customer.update_attributes(@params['customer']) if @customer
    redirect :action => :index
  end

  # POST /Customer/{1}/delete
  def delete
    @customer = Customer.find(@params['id'])
    @customer.destroy if @customer
    redirect :action => :index  
  end
end
