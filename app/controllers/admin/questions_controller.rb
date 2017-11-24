module Admin
  class QuestionsController < AdminController

    load_and_authorize_resource

    def index
      @questions = Question.all.order(:position)
    end

    def new
      @question = Question.new
    end

    def create
      @question = Question.new(question_params)
      if @question.save
        redirect_to admin_questions_path, notice: t('backend.successfully_created_record')
      else
        flash[:alert] = t('backend.review_errors')
        render :new
      end
    end

    def edit
      @question = Question.find(params[:id])
    end

    def update
      @question = Question.find(params[:id])
      if @question.update_attributes(question_params)
        redirect_to admin_questions_path, notice: t('backend.successfully_created_record')
      else
        flash[:alert] = t('backend.review_errors')
        render :new
      end
    end

    def destroy; end

    private

      def question_params
        params.require(:question)
              .permit(:title, :answer, :position)
      end

  end
end
