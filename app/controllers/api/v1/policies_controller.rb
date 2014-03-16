module Api
  module V1
    class PoliciesController < ApplicationController
      # GET /api/v1/policies/production.txt
      def show
        policy_name=params[:name]
        categories=Category.all
        @policy=categories.inject({}) do |hsh, category|
          category_sites=category.sites.select {|s| s.policy == policy_name }
          hsh[category]=category_sites unless category_sites.empty?
          hsh
        end
        render action: 'show.txt.erb'
      end
    end
  end
end
