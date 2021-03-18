require 'rails_helper'

if RUBY_VERSION>='2.6.0'
  if Rails.version < '5'
    class ActionController::TestResponse < ActionDispatch::TestResponse
      def recycle!
        @mon_mutex_owner_object_id = nil
        @mon_mutex = nil
        initialize
      end
    end
  else
    puts "Monkeypatch for ActionController::TestResponse no longer needed"
  end
end

describe MoviesController do
  describe 'search movies by the same director' do
      let!(:m1) { FactoryBot.create(:movie, title: 'Movie1', director: 'Director1') }
      it 'should call Movie.same_director' do
        expect(Movie).to receive(:same_director).with(Movie.find(m1.id))
        get :search, { id: m1.id }
      end

      context 'movie has a director' do
          let!(:m1) { FactoryBot.create(:movie, title: 'Movie1', director: 'Director1') }
          let!(:m2) { FactoryBot.create(:movie, title: 'Movie2', director: 'Director2') }
          let!(:m3) { FactoryBot.create(:movie, title: 'Movie3', director: 'Director1') }
          
        
          
          it 'should assign similar movies if director exists' do
                get :search, {id: m1.id}
                expect(assigns(:movies)).to include(m3)
                expect(assigns(:movies)).to_not include(m2)
          end
      end
      context 'movie has no director' do
          let!(:m4) { FactoryBot.create(:movie, title: 'Movie4' ) }
          it "should redirect to home page if director isn't known" do
              Movie.stub(:same_director).with(Movie.find(m4.id)).and_return(nil)
              get :search, {id: m4.id}
              expect(response).to redirect_to(movies_path)
          end
      end    
  end
  
  describe 'GET index' do
        let!(:movie) {FactoryBot.create(:movie)}
        it 'should render the index template' do
          get :index
          expect(response).to render_template('index')
        end
    end
  describe 'GET new' do
        let!(:movie) { Movie.new }
        it 'should render the new template' do
        get :new
        expect(response).to render_template('new')
    end
  end


    describe 'GET #edit' do
        let!(:movie) { FactoryBot.create(:movie) }
        before do
          get :edit, id: movie.id
        end
    
        it 'should find the movie' do
          expect(assigns(:movie)).to eql(movie)
        end
    
        it 'should render the edit template' do
          expect(response).to render_template('edit')
        end
    end
     describe 'GET #show' do
        let!(:movie) { FactoryBot.create(:movie)}
        before(:each) do
          get :show, id: movie.id
        end
    
        it 'should find the movie' do
          expect(assigns(:movie)).to eql(movie)
        end
    
        it 'should render the show template' do
          expect(response).to render_template('show')
        end
    end
    
    describe 'POST #create' do
        it 'creates a new movie' do
          expect {post :create, movie: FactoryBot.attributes_for(:movie)}.to change { Movie.count }.by(1)
        end
    end
    
    describe 'PUT #update' do
        let(:movie) { FactoryBot.create(:movie) }
        before(:each) do
          put :update, id: movie.id, movie: FactoryBot.attributes_for(:movie, title: 'Updated')
        end

        it 'updates an existing movie' do
          movie.reload
          expect(movie.title).to eql('Updated')
        end

        it 'redirects to the movie page' do
          expect(response).to redirect_to(movie_path(movie))
        end
  end

end 

