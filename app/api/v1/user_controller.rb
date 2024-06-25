module V1
  class UserController < Grape::API
    version 'v1'
    format :json

    resource :user do
      desc 'Get all the users'
      get do
        UserHelper.all_users
      end
    end
  end
end
