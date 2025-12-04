class DemoController < ApplicationController
  # No layout for full CoreUI test page
  layout false

  def index
    # Just renders app/views/demo/index.html.erb
  end
end
