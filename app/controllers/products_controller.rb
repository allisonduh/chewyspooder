
class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    #Scraper.new.scrape_chewy
    @product_search = Product.search_ingredients(params[:ingredientsyes],params[:ingredientsno]).all

    # @products = @products.filter_by_ingredient(params[:ingredients]) if params[:ingredients].present?
    # @product_searchno = Product.searchno(params[:searchno]).all 
    # parameter within model needs to be present on controller.
    # productlist=Product.all; render json: productlist # requires serializer file

  end

  # GET /products/1 or /products/1.json
  def show
  end

  
  # GET /products/new
  def new
    @product = Product.new
  end

  def search
    
  end

  def reset
    @product_search=Product.all
  end


  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    @product = Product.new(product_params)

      
    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:brand,:caloriespercan,:ingredients,:url,:ingredientsyes,:ingredientsno)
    end
end
