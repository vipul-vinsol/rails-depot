class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # GET /products
  # GET /products.json
  def index
    @products = Product.all
    respond_to do |format|
      format.json { render json: Product.select('products.title AS Name', 'categories.title AS Category').joins(:category) }
      format.html
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    get_rating_object
  end

  # GET /products/new
  def new
    @product = Product.new
    @categories = Category.all.map {|c| [ c.title, c.id ] }
  end

  # GET /products/1/edit
  def edit
    @categories = Category.all.map {|c| [ c.title, c.id ] }
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)
    @categories = Category.all.map {|c| [ c.title, c.id ] }
    
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product,
          notice: 'Product was successfully created.' }
        format.json { render :show, status: :created,
          location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors,
          status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product,
          notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }

        @products = Product.all
        ActionCable.server.broadcast 'products',
          html: render_to_string('store/index', layout: false)
      else
        format.html { render :edit }
        format.json { render json: @product.errors,
          status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url,
          notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def who_bought
    @product = Product.find(params[:id])
    @latest_order = @product.orders.order(:updated_at).last
    if stale?(@latest_order)
      respond_to do |format|
        format.html
        format.xml
        format.atom
        format.json { render json: @product.to_json(include: :orders) }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white
    # list through.
    def product_params
      params.require(:product).permit(:title, :description, :image_url, :price, :enabled, 
        :discount_price, :permalink, :category_id, product_images: [])
    end

    def get_rating_object
      if @product.ratings.exists?
        @rating = Rating.new
        @rating = @product.ratings.find { |rating| rating.user_id = current_user.id }
      else
        @rating = Rating.new
      end
    end
end
