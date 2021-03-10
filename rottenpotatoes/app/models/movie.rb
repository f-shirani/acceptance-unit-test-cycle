class Movie < ActiveRecord::Base
     def self.similar_movies
        director = Movie.find_by(title: movie_title).director
        return nil if director.blank? 
        Movie.where(director: director).pluck(:title)
    end
end
 