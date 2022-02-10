require 'swagger_helper'

describe 'Authorization' do
  path '/v1/authorization/login' do
    post 'User authentication' do
      tags 'Authorization'
      produces 'application/json', 'application/xml'
      security [bearer: {}]
      parameter name: :request, in: :body, schema: {
          type: :object,
          properties: {
              username: {type: :string, required: true},
              password: {type: :string, required: true},
          }
      }

      response '200', 'The user was successfully authenticated' do
        schema type: :object,
               properties: {
                   user: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           username: {type: :string},
                           type_user_id: {type: :integer},
                           created_at: {type: :string},
                           updated_at: {type: :string}
                       }
                   } ,
                   access_token: { type: :string }
               }

        let(:Authorization) { 'Bearer some_token' }
        run_test!
      end

      response '401', 'The user could not be authenticated' do
        schema type: :object,
               properties: {
                   message: { type: :string }
               }

        run_test!
      end
    end
  end
  path '/v1/authorization/logout' do
    post 'Logout user' do
      tags 'Authorization'
      consumes 'application/json'
      parameter name: :request, in: :body, schema: {
          type: :object,
          properties: {
              access_token: {type: :string, required: true}
          }
      }

      response '200', 'Token deleted' do
        schema type: :object,
               properties: {
                   message: {
                       type: :string,
                   }
               }
        run_test!
      end
      response '404', 'Token not found' do
        schema type: :object,
               properties: {
                   message: {
                       type: :string,
                   }
               }
        run_test!
      end
    end
  end
  path '/v1/authorization/forgot_password' do
    post 'Request reset password' do
      tags 'Authorization'
      consumes 'application/json'
      parameter name: :request, in: :body, schema: {
          type: :object,
          properties: {
              email: {type: :string, required: true}
          }
      }

      response '200', 'Email sent to user' do
        schema type: :object,
               properties: {
                   message: {
                       type: :string,
                   }
               }
        run_test!
      end
      response '404', 'Account not found' do
        schema type: :object,
               properties: {
                   message: {
                       type: :string,
                   }
               }
        run_test!
      end
    end
  end
end