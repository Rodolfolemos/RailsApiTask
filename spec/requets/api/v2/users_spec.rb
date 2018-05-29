require 'rails_helper'

RSpec.describe 'Users Api', type: :request do
  let!(:user) { create(:user) }
  let(:user_id) {  user.id  }
  let(:headers) do 
    {
      'Accept' => 'application/vnd.taskmanager.v2',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => user.auth_token

    }
    
  end

  before { host! "api.qualquerdominio.test"}

    describe "GET /users/:id" do
      before do
        get "/users/#{user_id}", params: {}, headers: headers
      end

      context "when the user exist" do
        it "returns the user" do
          expect(json_body[:data][:id].to_i).to eq(user_id)
        end

        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        context "when the user does not exists" do
          let!(:user_id) { 100000 }

          it "returns status code 404" do
            expect(response).to have_http_status(404)
            
          end
          
        end
        

      end
      

    end

    describe "POST /users" do
      before do
        post '/users', params: { user: user_params }.to_json, headers: headers
      end

      context "when the requests params are valid" do
        let(:user_params) { attributes_for(:user) }

        it 'returns status code 201' do
          expect(response).to have_http_status(201)
        end

        it 'returns json data for the created user' do
          expect(json_body[:data][:attributes][:email]).to eq(user_params[:email])
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
    
    describe "PUT /users/:id" do
    before do
        put "/users/#{user_id}", params: { user: user_params }.to_json, headers: headers
      end

      context "when the request params are valid" do
        let(:user_params) { { email: 'taskmnew@email.com' } }

        it "returns status code 200" do
          expect(response).to have_http_status(200)
        end
        it "returns json data for the update user" do
          expect(json_body[:data][:attributes][:email]).to eq(user_params[:email])  
        end
      end

      context "when the request params are invalid" do
        let(:user_params) { { email: 'invalidemail@' } }

        it "returns status code 422" do
          expect(response).to have_http_status(422)
        end
        it "returns json data for the errors" do
          expect(json_body).to have_key(:errors)
        end
      end

    
    end

    describe "DELETE /users/:id" do
      before do
        delete "/users/#{user_id}", params: {}, headers: headers
      end
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the user from datbase' do
        expect( User.find_by(id: user.id) ).to be_nil   
        
      end
    end
    
    

end