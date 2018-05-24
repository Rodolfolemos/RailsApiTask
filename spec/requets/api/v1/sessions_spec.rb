require 'rails_helper'

RSpec.describe 'Sessions API', type: request do
  before { host! 'api.taskmanager.test' } 
  let(:user) { create(:user)  }
  let(:headers) do
    {
      'Accept' => 'application/vnd.taskmanager.v1',
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'POST /sessions' do
    
  end

end