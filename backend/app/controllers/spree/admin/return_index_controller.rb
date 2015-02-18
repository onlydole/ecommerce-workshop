module Spree
  module Admin
    class ReturnIndexController < BaseController
      define_callbacks :load_collection
      #set_callback :load_collection, :after, :paginate_collection
      set_callback :load_collection, :after, :search

      def return_authorizations
        @collection = collection(Spree::ReturnAuthorization)
        respond_with(@collection)
      end

      def customer_returns
        @collection = collection(Spree::CustomerReturn)
        respond_with(@collection)
      end

      private

      def collection(resource)
        return @collection if @collection.present?
        params[:q] ||= {}

        @collection = resource.all
        # @search needs to be defined as this is passed to search_form_for
        @search = @collection.ransack(params[:q])
        @collection = @search.result.
              page(params[:page]).
              per(params[:per_page] || Spree::Config[:admin_products_per_page])

        @collection
      end

      def paginate_collection
        @collection = @collection.order(id: :desc).
          page(params[:page]).
          per(params[:per_page] || Spree::Config[:admin_products_per_page])
      end

      def search
        @search = @collection.ransack(params[:q])
        @collection = @search.result
      end
    end
  end
end
