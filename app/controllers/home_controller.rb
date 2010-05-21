class HomeController < ApplicationController
  def index
  end

  def trains
    @coords = Train.all.collect do |t|
      lat, lng = t.coords
      {:id => t.id, :lat => lat, :lng => lng}
    end

    render :json => @coords
  end

  def add_train
    @train = Train.new(params[:train])
    if request.post?
      redirect_to :action => 'index' if @train.save
    end
  end

end
