# frozen_string_literal: true

module CustomFailureApp
  class FailureApp < Devise::FailureApp
    def respond
      if request.content_type == 'application/json'
        json_api_error_response
      else
        super
      end
    end

    def json_api_error_response
      self.status        = 401
      self.content_type  = 'application/json'
      self.response_body = { status: { code: 401, message: i18n_message } }.to_json
    end
  end
end
