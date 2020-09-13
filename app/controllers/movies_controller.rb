class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort = params[:sort]
    if(sort == 'sort_by_title') then
      @movies = Movie.order(title: :asc)
      @title_header = 'hilite'
    elsif(sort == 'sort_by_release_date') then
      @movies = Movie.order(release_date: :asc)
      @release_header = 'hilite'
    elsif(!sort.present? && (params[:ratings].present? and params[:ratings].any?)) then
      @movies = Movie.with_ratings(deep_hash_keys(params[:ratings]))
    else
      @movies = Movie.all
    end
    @all_ratings=Movie.select(:rating).map(&:rating).uniq.sort
    @selected_ratings = (params["ratings"].present? ? params["ratings"] : @all_ratings)
  end
  
  def deep_hash_keys(h)
    h.keys + h.map { |_, v| v.is_a?(Hash) ? deep_hash_keys(v) : nil }.flatten.compact
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
