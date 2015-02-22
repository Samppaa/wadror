class RatingsController < ApplicationController



  def index
    @ratings = Rating.all
    @top_raters = get_top_raters(3)
    @recent_ratings = Rating.recent
    @top_beers = get_top_beers(3)
    @top_breweries = Brewery.top(3)
    @top_styles = Style.top(3)
  end

  def destroy
    rating = Rating.find params[:id]
    rating.delete if current_user == rating.user
    redirect_to :back
  end

  def get_top_raters (n)
    sorted_by_number_of_ratings = User.all.sort_by { |b| -(b.ratings.count) }
    return sorted_by_number_of_ratings[1, n]
  end

  def get_top_beers (n)
    sorted_by_ratings = Beer.all.sort_by { |b| -(b.average) }
    return sorted_by_ratings[1,n]
  end


  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end
end