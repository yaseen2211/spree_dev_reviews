class Spree::Admin::ReviewsController < Spree::Admin::ResourceController
  helper Spree::ReviewsHelper

  def index
    @reviews = collection
  end

  def approve
    review = Spree::Review.find(params[:id])
    if review.update_attribute(:approved, true)
      product = review.product
      user = review.user
      Spree::UserMailer.inform_user_approve_review(user,product).deliver_now
      flash[:notice] = Spree.t(:info_approve_review)
    else
      flash[:error] = Spree.t(:error_approve_review)
    end
    redirect_to admin_reviews_path
  end

  def edit
    return if @review.product
    flash[:error] = Spree.t(:error_no_product)
    redirect_to admin_reviews_path
  end

  private

  def collection
    params[:q] ||= {}
    @search = Spree::Review.ransack(params[:q])
    @collection = @search.result.includes([:product, :user, :feedback_reviews]).page(params[:page]).per(params[:per_page])
  end
end
