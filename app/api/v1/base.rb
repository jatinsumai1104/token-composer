module V1
  class Base < Grape::API
    prefix 'api'
    mount V1::TokenController
  end
end
