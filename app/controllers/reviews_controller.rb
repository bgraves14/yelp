class ReviewsController < ApplicationController
  def new
    @restaurnt = Restaurant.find(params[:restaurant_id])
    @review = Review.new
  end

  def create
    @restaurnt = Restaurant.find(params[:restaurant_id])
    @restaurant.reviews.create(reviews_params)
  end

  def review_params
    params.require(:review).permit(:thoughts, :rating)
  end

end
