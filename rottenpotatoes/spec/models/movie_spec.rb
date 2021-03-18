require 'rails_helper'

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        # hack to avoid MonitorMixin double-initialize error:
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe Movie  do
    describe '#same_director' do
        context 'find all movies with the same director' do
          let!(:movie1) { FactoryBot.create(:movie, title: 'Movie1', director: 'Director1') }
          let!(:movie2) { FactoryBot.create(:movie, title: 'Movie2', director: 'Director2') }
          let!(:movie3) { FactoryBot.create(:movie, title: 'Movie3', director: 'Director1') }
          
      
          subject { Movie.same_director(movie1.id) }
          it {expect(subject).to include(movie3) }
          it {expect(subject).to_not include(movie2) }
        end
        
        context 'director does not exist' do
            let!(:movie4) { FactoryBot.create(:movie, title: 'Movie4') }
            it 'handles sad path'  do
              expect(Movie.same_director(movie4.id)).to eq(nil)
            end
        end
   
    end
end



