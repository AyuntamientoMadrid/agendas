module Admin
  class QuestionsController < AdminController

    load_and_authorize_resource

    def index
      @questions = Question.all.order(:position)
      respond_to :html, :js
    end

    def new
      @question = Question.new
      @legend_title = t('backend.faq.new_question_legend')
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
      @legend_title = t('backend.faq.edit_question_legend')
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

    def destroy
      @question = Question.find(params[:id])
      @question.destroy
      redirect_to admin_questions_path, notice: t('backend.successfully_destroyed_record')
    end

    def order
      Question.order_answers(params[:ordered_list])
      redirect_to admin_questions_path
    end

    private

      def question_params
        params.require(:question)
              .permit(:title, :answer, :position)
      end

  end
end
