require_relative 'controller'

class PostsController < ApplicationController
    def index
        render "Hello from PostsController#index"
    end

    def show id
        render "Showing post with ID: #{id}"
    end
end