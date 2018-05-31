require 'rails_helper'

RSpec.describe 'Users Api', type: :request do
  let!(:user) { create(:user) }
  let!(:auth_data)  { user.create_new_auth_token }
  let(:headers) do 
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  before { host! "api.qualquerdominio.test"}

    describe 'GET /auth/validate_token' do
      
      context 'when the request headers are valid' do
        before do
          get '/auth/validate_token', params: {}, headers: headers
        end
        it 'returns the user' do
          expect(json_body[:data][:id].to_i).to eq(user.id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        context 'when the request headers are invalid' do
          before do
            headers['access-token'] = "invalid_token"
            get '/auth/validate_token', params: {}, headers: headers
          end

          it 'returns status code 401' do
            expect(response).to have_http_status(401)
            
          end
          
        end
        

      end
      

    end

    describe "POST /auth" do
      before do
        post '/auth', params: user_params.to_json, headers: headers
      end

      context "when the requests params are valid" do
        let(:user_params) { attributes_for(:user) }

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns json data for the created user' do
          expect(json_body[:data][:email]).to eq(user_params[:email])
        end

      end

      context "when the resquests params are invalid" do
        let(:user_params) { attributes_for(:user, email: 'invalidemail@') }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end
        
        it 'returns json data for the erros' do
          expect(json_body).to have_key(:errors)  
        end
        
        
      end
      
    end
    
    describe 'PUT /auth' do
    before do
        put '/auth', params: user_params.to_json, headers: headers
      end

      context 'when the request params are valid' do
        let(:user_params) { { email: 'taskmnew@email.com' } }

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end
        it 'returns json data for the update user' do
          expect(json_body[:data][:email]).to eq(user_params[:email])  
        end
      end

      context 'when the request params are invalid' do
        let(:user_params) { { email: 'invalidemail@' } }

        it 'returns status code 422' do
          expect(response).to have_http_status(422)
        end
        it 'returns json data for the errors' do
          expect(json_body).to have_key(:errors)
        end
      end

    
    end

    describe 'DELETE /auth' do
      before do
        delete '/auth', params: {}, headers: headers
      end
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'removes the user from datbase' do
        expect( User.find_by(id: user.id) ).to be_nil   
        
      end
    end
    
    

end