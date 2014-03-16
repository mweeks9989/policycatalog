module Api
  module V1
    class CategoriesController < ApplicationController
      def index
        render json: Category.all
      end

      def show
        render json: Category.where(name: params[:id])
      end

      def update
        Rails.logger.info JSON.pretty_generate(request)
      end
    end
  end
end
