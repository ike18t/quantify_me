require_relative '../spec_helper'

describe ViewHelpers do
  before :each do
    def session
      Rack::Test::Session.new(Rack::MockSession.new(app))
    end
  end

  context 'greetings' do
    it 'should render the logged_in partial if the session has a user' do
      allow(session).to receive(:has_key?).and_return(true)
      allow(subject).to receive(:haml).with(:_logged_in)
      Class.new.extend(ViewHelpers).greetings
    end

    it 'should render the login partial if the session does not have a user' do
      allow(session).to receive(:has_key?).and_return(false)
      allow(subject).to receive(:haml).with(:_login)
      subject.greetings
    end
  end
end
