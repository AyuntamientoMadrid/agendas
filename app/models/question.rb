class Question < ActiveRecord::Base
  validates :position, presence: true, uniqueness: true
  validates :title, :answer, presence: true

  before_validation :set_position, on: :create

  def self.order_answers(ordered_array)
    ordered_array.each_with_index do |question_id, order|
      find(question_id).update_attribute(:position, (order + 1))
    end
  end

  def set_position
    return unless position.nil?
    next_position = self.class.last_position + 1
    self.position = next_position
  end

  def self.last_position
    maximum("position") || 0
  end

end
