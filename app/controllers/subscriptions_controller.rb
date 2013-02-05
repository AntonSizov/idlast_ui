 class SubscriptionsController < ApplicationController

  # load_and_authorize_resource
  before_filter :authenticate_user!

  def index
    @title = "All subscriptions"
    @subscriptions = Subscription.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @subscription = Subscription.new
    @current_method = "new"
  end

  def create
    @subscription = current_user.subscriptions.new(params[:subscription])
    @subscription.email = current_user.email
    @subscription.user_name = current_user.name

    if @subscription.save
      redirect_to(user_path(current_user), :notice => 'Subscription was successfully created.')
    else
      render :action => "new"
    end

  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    redirect_to(:back)
  end

end
