# frozen_string_literal: true

module Spree
  module Admin
    class ProductUploadsController < ResourceController
      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      def create
        @object.attributes = permitted_resource_params
        if @object.save
          flash[:success] = flash_message_for(@object, :successfully_created)

          start_import(@object.id)

          respond_with(@object) do |format|
            format.html { redirect_to location_after_save }
          end
        else
          respond_with(@object) do |format|
            format.html { render action: :new }
          end
        end
      end

      protected

      def permitted_resource_params
        params.require(:product_upload).permit(:file, :upload_type)
      end

      def collection
        return @collection if @collection.present?

        @collection = super
        @collection = @collection.page(params[:page])
                                 .per(params[:per_page] || Spree::Config[:admin_products_per_page])
      end

      private

      def start_import(upload_id)
        ProductsImportWorker.perform_async(upload_id)
      end
    end
  end
end
