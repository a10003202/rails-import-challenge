require 'swagger_helper'

describe 'API' do
  path '/v1/users' do
    get 'Get users' do
      tags 'Users'
      produces 'application/json', 'application/xml'
      security [bearer: {}]

      response '200', 'Users list' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: {type: :integer, example:1},
                   name: {type: :string},
                   created_at: {type: :string, format: 'date-time'},
                   updated_at: {type: :string, format: 'date-time'},
                 }
               }
        run_test!
      end

      response '401', 'Authorization information is missing or invalid.' do
        run_test!
      end
    end
  end
  path '/users' do
    post 'Creates a User' do
      tags 'Users'
      consumes 'application/json'
      security [bearer: {}]
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string }
        },
        required: [ 'name', 'email' ]
      }

      response '201', 'User successfully created' do
        schema type: :object,
               properties: {
                 message: { type: :string },
                 user: {
                   type: :object,
                   properties: {
                     id: {type: :integer, example: 1}
                   }
                 }
               }
        let(:user) { { id: 'foo', name: 'bar' } }
        run_test!
      end
      response '401', 'Authorization information is missing or invalid.' do
        run_test!
      end
      response '404', 'Resource not found' do
        schema type: :object,
               properties: {
                 message: {
                   type: :string
                 }
               }
        run_test!
      end
      response '422', 'User could not be created' do
        schema type: :object,
               properties: {
                 success: {type: :boolean},
                 errors: {
                   type: :array,
                   items: {type: :string}
                 }
               }
        run_test!
      end
    end
  end

  path '/v1/users/{id}' do
    patch 'Update a user' do
      tags 'Users'
      consumes 'application/json'
      security [bearer: {}]
      parameter name: :id, in: :path, type: :string
      parameter name: :user, in: :body, schema: {
        type: :object,
        properties: {
          name: {type: :string, required: true},
          password: {type: :string, required: true},
        }
      }

      response '200', 'User updated' do
        schema type: :object,
               properties: {
                 id: {type: :integer,example:1},
                 name: {type: :string},
               }
        run_test!
      end
      response '401', 'Authorization information is missing or invalid.' do
        run_test!
      end
      response '422', 'User could not be updated' do
        schema type: :object,
               properties: {
                 success: {type: :boolean},
                 errors: {
                   type: :array,
                   items: { type: :string }
                 }
               }
        run_test!
      end
    end
  end

  path '/users/{id}' do

    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json', 'application/xml'
      security [bearer: {}]
      parameter name: :id, in: :path, type: :string, required: true, description: 'User ID'

      response '200', 'User found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 created_at: {type: :string, format: 'date-time'},
                 updated_at: {type: :string, format: 'date-time'},
               },
               required: [ 'id', 'title', 'content' ]

        let(:id) { User.create(title: 'foo', content: 'bar').id }
        run_test!
      end

      response '401', 'Authorization information is missing or invalid.' do
        run_test!
      end

      response '404', 'Resource not found' do
        schema type: :object,
               properties: {
                 message: {
                   type: :string
                 }
               }
        let(:id) { 'invalid' }
        run_test!
      end

      response '406', 'unsupported accept header' do
        let(:'Accept') { 'application/foo' }
        run_test!
      end
    end
  end
  path '/v1/users/{id}' do
    delete 'Delete user' do
      tags 'Users'
      produces 'application/json', 'application/xml'
      security [bearer: {}]
      parameter name: :id, in: :path, type: :string

      response '204', 'User deleted' do
        schema type: :object,
               properties: {
                 success: {type: :boolean},
                 message: {type: :string}
               }
        run_test!
      end

      response '401', 'Authorization information is missing or invalid.' do
        run_test!
      end

      response '422', 'User could not be deleted' do
        schema type: :object,
               properties: {
                 success: {type: :boolean},
                 errors: {
                   type: :array,
                   items: {type: :string}
                 }
               }
        run_test!
      end
    end
  end

  path '/v1/users/search' do
    get 'Get users' do
      tags 'Users'
      produces 'application/json', 'application/xml'
      security [bearer: {}]
      parameter name: :search, in: :query, type: :string, description: 'Search value'
      parameter name: :sort_column, in: :query, type: :integer, default: 0, description: "Sort column index:\n * 0 - Description\n * 1 - Analyte Name\n * 2 - Branches number\n * 3 - Category Name"
      parameter name: :sort_direction, in: :query, type: :string, default:'asc', enum: ['asc', 'desc'], description: "Sort order:\n * `asc` - Ascending\n * `desc` - Descending\n"
      parameter name: :page_index, in: :query, type: :integer, default: 0, description: 'Index of page (Beginning from 0)'
      parameter name: :page_size, in: :query, type: :integer, default: 10, description: 'Number of records by page'

      response '200', 'Users paginated' do
        schema type: :object,
               properties: {
                 draw: {type: :integer},
                 recordsTotal: {type: :integer},
                 recordsFiltered: {type: :integer},
                 data: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: {type: :integer, example:1},
                       name: {type: :string},
                     }
                   }
                 }
               }
        run_test!
      end

      response '401', 'Authorization information is missing or invalid.' do
        run_test!
      end
    end
  end
end