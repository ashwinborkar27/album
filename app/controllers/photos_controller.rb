class PhotosController < ApplicationController
	 before_action :set_photo, only: %i[ show edit]


  def index
    params[:tag] ? @photos = Photo.tagged_with(params[:tag]) : @photos = Photo.all
    album = params[:album_id]
    @photos = current_user.photos.all.where(album_id: album).with_attached_pictures

  end

  
  def show

  end

  
  
  def new
    @photo = Photo.new
  end

  
  def edit
    # @photo = Photo.find(params[:id])
  end

  
  def create
    @photo = Photo.new(photo_params)
    @photo.album_id = params[:album_id]
    @photo.user_id = current_user.id
    # @photo.pictures.attach(params[:photo][:picture])
    respond_to do |format|
      if @photo.save(validate: false)
        format.html { redirect_to album_photos_path , notice: "Photo was successfully created." }
        format.json { render :show, status: :created, location: @photo }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @photo = Photo.with_attached_pictures.find(params[:id])
     @photo.user_id = current_user.id
    respond_to do |format|
      if @photo.update(photo_params)
      # raise @photo.inspect
        format.html { redirect_to album_photos_path, notice: "Photo was successfully updated." }
        format.json { render :show, status: :ok, location: @photo }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @photo = Photo.find(params[:id])
    @album = @photo.album_id
    @photo.destroy
    respond_to do |format|
      format.html { redirect_to album_photos_path, notice: "Photo was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_photo
      @photo = Photo.with_attached_pictures.find(params[:id])
    end

    def photo_params
      params.require(:photo).permit(:album_id, :user_id, :tag_list, :tag, { tag_ids: [] }, :tag_ids, pictures: [])
    end
end
