class Movie < ActiveRecord::Base
    
    # class method of finding all movies with same director
    # 
    def self.same_director(id)
        movie = self.find(id)
        if !movie.director.blank?
            movies=self.where(:director => movie.director).where.not(:id => movie.id)
            return movies, false
        else
            return [], true
        end
    end
    
    def self.all_ratings
    %w(G PG PG-13 NC-17 R)
    end

  
end
