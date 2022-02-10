class GalleriesController < ApplicationController
  before_action :set_gallery, only: %i[ show edit update destroy ]
  before_action :set_owner, only: [:create_images, :destroy_images, :get_by_owner]

  # GET /galleries or /galleries.json
  def index
    @galleries = Gallery.all
  end

  # GET /galleries/1 or /galleries/1.json
  def show
    respond_to do |format|
      format.html
      format.json {render json: @gallery.as_json(include: [:owner], methods: [:size])}
    end
  end

  # GET /galleries/new
  def new
    @gallery = Gallery.new
  end

  # GET /galleries/1/edit
  def edit
  end

  # POST /galleries or /galleries.json
  def create
    gallery_attributes = gallery_params
    @gallery = Gallery.new(gallery_attributes)
    if gallery_attributes[:file].present?
      @gallery.name = gallery_attributes[:file].original_filename if gallery_attributes[:file].is_a?(ActionDispatch::Http::UploadedFile)
    end

    respond_to do |format|
      if @gallery.save
        format.html { redirect_to @gallery, notice: "Gallery was successfully created." }
        format.json { render :show, status: :created, location: @gallery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /galleries/1 or /galleries/1.json
  def update
    gallery_attributes = gallery_params
    @gallery.attributes = gallery_attributes.except(:file)
    if gallery_attributes[:file].present?
      @gallery.name = gallery_attributes[:file].original_filename if gallery_attributes[:file].is_a?(ActionDispatch::Http::UploadedFile)
      @gallery.file = gallery_attributes[:file] if gallery_attributes[:file].is_a?(ActionDispatch::Http::UploadedFile)
    else
      @gallery.name = nil
      @gallery.remove_file!
    end
    respond_to do |format|
      if @gallery.save
        format.html { redirect_to @gallery, notice: "Gallery was successfully updated." }
        format.json { render :show, status: :ok, location: @gallery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @gallery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /galleries/1 or /galleries/1.json
  def destroy
    respond_to do |format|
      if @gallery.destroy
        format.html { redirect_to galleries_url, notice: 'Gallery was successfully destroyed.' }
        format.json { head :no_content }
      else
        format.html { redirect_to galleries_url, notice: 'Gallery was not successfully destroyed.' }
        format.json { render json: {errors: @gallery.errors.full_messages}, status: :unprocessable_entity }
      end
    end
  end


  def create_images
    param_images = params[:images]
    orders = params[:orders]
    if param_images.present?
      param_images.each do |index, param_image|
        index = index.to_i
        order = nil
        if orders.present? && orders[index].present?
          order = orders[index]
        end
        image = Gallery.create(name: param_image.original_filename, file: param_image, owner: @owner, order:order)
      end
    end
    render json: {success:true}
  end

  def destroy_images
    images_ids = params[:images]
    images_ids.each do |image_id|
      image = Gallery.find(image_id)
      if image
        image.destroy
      end
    end
    render json: {success:true}
  end

  def order_images

    if params[:images].present?
      begin
        Gallery.transaction do
          params[:images].each do |param_image|
            image = Gallery.find_by(id: param_image[:id])
            if image
              image.order = param_image[:order]
              image.save!
            end
          end
        end
        render json: {:success => true}
      rescue => e
        p e.message
        render json: {:success => false, :message => "No se pudo actualizar el orden"}
      end
    else
      render json: {:success => true}
    end
  end

  def get_by_owner
    images = []
    if @owner
      images = @owner.galleries
    end
    render json: images, :methods => [:size]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gallery
      @gallery = Gallery.find(params[:id])
    end

    def set_owner
      owner_id = params[:owner_id]
      owner_type = params[:owner_type]
      case owner_type
      when User.name
        @owner = User.find(owner_id)
      end
    end

    # Only allow a list of trusted parameters through.
    def gallery_params
      params.require(:gallery).permit(:name, :file, :image_type, :order, :owner_id, :owner_type)
    end
end
