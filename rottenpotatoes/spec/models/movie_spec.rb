require 'rails_helper'

describe Movie do
  describe '.find_similar_movies' do
    let!(:movie1) { FactoryBot.create(:movie, title: 'Hitchcock', director: 'Tarantino') }
    let!(:movie2) { FactoryBot.create(:movie, title: 'Anaconda', director: 'Luis Llosa') }
    let!(:movie3) { FactoryBot.create(:movie, title: 'Celebrity', director: 'Tarantino') }
    let!(:movie4) { FactoryBot.create(:movie, title: 'Stop') }

    context 'director exists' do
      it 'finds similar movies correctly' do
        expect(Movie.same_director(movie1.title)).to eql(['Hitchcock', "Celebrity"])
        expect(Movie.same_director(movie1.title)).to_not include(['Anaconda'])
        expect(Movie.same_director(movie2.title)).to eql(['Anaconda'])
      end
    end

    context 'director does not exist' do
      it 'handles sad path' do
        expect(Movie.same_director(movie4.title)).to eql(nil)
      end
    end
  end
end


