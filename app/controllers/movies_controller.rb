class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    sort_criteria = params[:sort]
    filter_criteria = params[:ratings]

    unless session[:ratings]
      session[:ratings] = Hash[Movie.all_ratings.map {|x| [x, 1]}]
    end

    unless session[:sort]
      session[:sort] = :id
    end
    if sort_criteria or session[:sort] == :id
      session[:sort] = sort_criteria 
      (session[:ratings] = filter_criteria) if filter_criteria 
      @movies = Movie.where(:rating => (filter_criteria ? filter_criteria.keys : session[:ratings].keys)).order(sort_criteria).all
      @all_ratings = Movie.all_ratings
    else
      flash.keep
      redirect_to movies_path :sort => session[:sort], :ratings => session[:ratings]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
