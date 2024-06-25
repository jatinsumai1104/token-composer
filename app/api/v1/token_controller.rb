module V1
  class TokenController < Grape::API
    version 'v1'
    format :json

    resource :keys do
      desc 'Generate Token'
      post do
        TokenHelper.new.generate_token
      end

      desc 'Get Token'
      get do
        TokenHelper.new.fetch_random_token
      end

      resource ':id' do
        desc 'Get Token Details'
        params do
          requires :id, type: String
        end
        get do
          # We can create entity instead of directly returning json
          TokenHelper.new.get_token(params[:id])
        end

        desc 'Delete Token'
        params do
          requires :id, type: String
        end
        delete do
          TokenHelper.new.delete_token(params[:id])
        end

        desc 'Unblock Token'
        params do
          requires :id, type: String
        end
        put do
          TokenHelper.new.unblock_token(params[:id])
        end
      end
    end

    desc 'Updating keep alive of token'
    params do
      requires :id, type: String
    end
    put 'keepalive/:id' do
      TokenHelper.new.update_alive_till(params[:id])
    end
  end
end
