class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :first_name, :admin, :created_at
end
