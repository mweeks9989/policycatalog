module Api
  module V1
    class SitesController < ApplicationController
      def index
        render json: Site.all
      end 

      def show
        policy = params.fetch(:policy,'production')
        site   = Site.where(uri: params[:id], policy: policy)
        render status: 404 if site.nil?
        render json:   site
      end

      def create
        render json: Site.create(site_params)
      end

      def uncategorize
        category = Category.find_by_name(params[:category_id])
        site     = Site.find_by_uri(params[:id])
        begin
          render json: site.categories.delete(category)
        rescue NoMethodError => exception
          render status: 422, json: {
            request_params:   params,
            site:     site,
            category: category,
            errors:   [
              { 
                site:     params[:id],
                category: params[:category_id],
                message:  "site not a member of this category"
              },{ 
                exception: exception.class.to_s, 
                message:   exception.message 
              }]
          }
        rescue Exception => exception
          render status: 422, json: {
            request_params:   params,
            site:     site,
            category: category,
            errors:   [{ 
              exception: exception.class.to_s, 
              message:   exception.message 
            }]
          }
        end
      end

      def categorize
        category = Category.find_by_name(params[:category_id])
        site     = Site.find_by_uri(params[:id])

        if site
          begin 
            site.categories << category
            render json: site
          # category not found or invalid
          rescue ActiveRecord::AssociationTypeMismatch => exception
            render status: 422, json: { 
              request_params:   params,
              site:     site,
              category: params[:category_id],
              errors:   [{ message: "Category not found or invalid"}]
            }
          # invalid categorization
          rescue ActiveRecord::RecordInvalid => exception
            render status: 422, json: { 
              request_params:   params,
              site:     site,
              category: category,
              errors:   [{ message: exception.message }]
            }
          end
        else
          render status: 404, json:  { 
            request_params: params,
            errors:         [{
              message: "site '#{params[:id]}' not found"
            }] 
          }
        end
        
      end

      private
      def site_params
        params.require(:site).permit(:uri,:comment,:policy)
      end
    end
  end
end
