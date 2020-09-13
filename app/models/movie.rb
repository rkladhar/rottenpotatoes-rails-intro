class Movie < ActiveRecord::Base
    def self.with_ratings(ratings)
        return Movie.where(rating: ratings)
    end
end
