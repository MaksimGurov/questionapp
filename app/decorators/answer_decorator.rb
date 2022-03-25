# frozen_string_literal: true

class AnswerDecorator < Draper::Decorator
  delegate_all
  decorates_association :user

  def formatted_created_at
    created_at.strftime('%Y-%m-%d %H:%M:%S')
  end
end
