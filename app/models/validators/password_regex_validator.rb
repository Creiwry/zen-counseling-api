# frozen_string_literal: true

module Validators
  class PasswordRegexValidator < ActiveModel::Validator
    def validate(record)
      return if record.password.blank? || record.password =~ /\A(?=.*\d)(?=.*[A-Z])(?=.*\W)[^ ]{6,}\z/

      record.errors.add :password,
                        'should have more than 6 characters including 1 uppercase letter, 1 number, 1 special character'
    end
  end
end
