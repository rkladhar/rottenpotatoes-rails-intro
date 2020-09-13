class Movie < ActiveRecord::Base
    def self.with_ratings(ratings)
        return Movie.all.where(rating: ratings) if ratings.present? and ratings.any?
    end
end
