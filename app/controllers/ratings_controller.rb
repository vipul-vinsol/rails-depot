class RatingsController < ApplicationController
  before_action :set_rating, only: [:update]

  def create
    @rating = Rating.new(rating_params)
    @rating.add_assosciated_product_id(params[:product][:id])
    @rating.add_logged_in_user_id(current_user.id)
    get_product(params[:product][:id])
    if @rating.save
      render json: { 
        averageRatingElementSelector: '.average-rating',
        averageRating: @product.ratings.average(:value)
      }
    end
  end

  def update
    get_product(@rating.product_id)
    if @rating.update(rating_params)
      render json: { 
        averageRatingElementSelector: '.average-rating',
        averageRating: @product.ratings.average(:value)
      }
    end
  end

  private
    def rating_params
      params.require(:rating).permit(:value)
    end

    def set_rating
      @rating = Rating.find_by(id: params[:id])
    end

    def get_product(product_id)
      @product = Product.find_by(id: product_id)
    end
end