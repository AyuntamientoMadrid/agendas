class QuestionsController < ApplicationController

  layout 'faq'

  def index
    @questions = Question.all.order(:position)
  end
end
