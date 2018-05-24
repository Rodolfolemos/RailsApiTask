require 'rails_helper'

RSpec.describe Api::V1::ApplicationController, type: :controller do
  describe 'include the corret concerns' do
    it { expect(controller.class.ancestors).to include(Authenticable)  } 
  end
end
