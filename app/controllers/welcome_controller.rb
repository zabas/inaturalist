class WelcomeController < ApplicationController
  def index
    # render :text => "<html><body>Nothing to see here, <a href='http://inaturalist.org'>move along, move along...</a></body></html>"
    redirect_to "http://inaturalist.org"
  end
end
