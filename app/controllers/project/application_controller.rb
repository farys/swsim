class Project::ApplicationController < ApplicationController
  before_filter :login_required
end