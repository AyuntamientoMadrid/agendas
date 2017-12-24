module Admin
  module Organizations
    class InterestsController < AdminController
      load_and_authorize_resource :organization

      def index; end

      def update
        if @organization.update(organization_interests_params)
          redirect_to admin_organization_interests_path(@organization),
                      notice: t('backend.successfully_updated_record')
        else
          flash[:alert] = t('backend.review_errors')
          render :edit
        end
      end

      private

        def organization_interests_params
          params.require(:organization).permit(interest_ids: [])
        end

    end
  end
end
