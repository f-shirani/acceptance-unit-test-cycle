require 'rails_helper'



describe MoviesController do
  describe 'search movies by the same director' do
    it 'should call Movie.same_director' do
      expect(Movie).to receive(:same_director).with('Space')
      get :search, { title: 'Space' }
    end

    it 'should assign similar movies if director exists' do
      movies = ['Hitchcock', 'Celebrity']
      Movie.stub(:same_director).with('Hitchcock').and_return(movies)
      get :search, { title: 'Hitchcock' }
      expect(assigns(:same_director)).to eql(movies)
    end

    it "should redirect to home page if director isn't known" do
      Movie.stub(:same_director).with('No name').and_return(nil)
      get :search, { title: 'No name' }
      expect(response).to redirect_to(root_url)
    end
  end

end 
