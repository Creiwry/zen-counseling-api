class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :created_at
end
