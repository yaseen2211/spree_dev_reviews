class Spree::ReviewsController < Spree::StoreController
  helper Spree::BaseHelper
  before_action :load_product, only: [:index, :new, :create]
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def index
    @approved_reviews = Spree::Review.approved.where(product: @product)
  end

  def new
    @review = Spree::Review.new(product: @product)
    authorize! :create, @review
  end

  # save if all ok
  def create
    if params[:from_rating].present?
      addRate
    else
      params[:review][:rating].sub!(/\s*[^0-9]*\z/, '') unless defined? (params[:review][:rating]) && params[:review][:rating].blank?
      @review = Spree::Review.new(review_params)
      @review.product = @product
      @review.user = spree_current_user if spree_user_signed_in?
      @review.ip_address = request.remote_ip
      @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]
      authorize! :create, @review
      if @review.save
        flash[:notice] = Spree.t(:review_successfully_submitted)
        redirect_to spree.product_path(@product)
      else
        render :new
      end
    end

  end

  private
  def addRate
    @review = Spree::Review.new(review_user_params)
    @review.product = @product
    @review.user = spree_current_user if spree_user_signed_in?
    @review.ip_address = request.remote_ip
    @review.locale = I18n.locale.to_s if Spree::Reviews::Config[:track_locale]
    authorize! :create, @review
     @review.save
    flash[:notice] = Spree.t(:review_successfully_submitted)
      redirect_to spree.edit_account_path(partial: "reviews", with_form: true)

  end

  def load_product
    @product = Spree::Product.friendly.find(params[:product_id])
  end

  def permitted_review_attributes
    [:rating, :title, :review, :name, :show_identifier]
  end

  def review_params
    params.require(:review).permit(permitted_review_attributes)
  end
  def review_user_params
    params.permit([:rating, :review, :name])
  end
end
