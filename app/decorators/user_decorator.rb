# frozen_string_literal: true

class UserDecorator < Draper::Decorator
  delegate_all # неизвестный метод который декорируем: никнейм, е-мейл

  def name_or_email
    return name if name.present?

    email.split('@')[0]
  end
end
