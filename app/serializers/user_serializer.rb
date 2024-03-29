# frozen_string_literal: true

class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :last_name, :admin, :created_at
end
