# frozen_string_literal: true

module Store
  class ItemsController < ApplicationController
    before_action :set_item, only: %i[show update destroy]
    before_action :authenticate_user!, except: %i[index show]
    before_action :check_if_admin, only: %i[create update destroy]

    # GET /items
    def index
      @items = Item.all

      items_array = []

      @items.each do |item|
        item = item.images.attached? ? item.as_json.merge(image: url_for(item.images[0])) : item.as_json.merge(image: nil)
        items_array << item
      end

      render_response(200, 'index rendered', :ok, items_array)
    end

    # GET /items/1
    def show
      images_array = []
      if @item.images.attached?
        @item.images.each do |image|
          images_array << url_for(image)
        end
      else
        images_array = nil
      end

      render_response(200, 'show item', :ok, @item.as_json.merge(images: images_array))
    end

    # POST /items
    def create
      @item = Item.new(item_params)

      if @item.save
        render_response(201, 'item created', :created, @item)
      else
        render_response(422, @item.errors, :unprocessable_entity, nil)
      end
    end

    # PATCH/PUT /items/1
    def update
      if @item.update(item_params)
        render_response(200, 'resource updated successfully', :ok, @item)
      else
        render_response(422, @item.errors, :unprocessable_entity, @item)
      end
    end

    # DELETE /items/1
    def destroy
      @item.destroy!
      render_response(200, 'resource deleted successfully', :ok, nil)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def check_if_admin
      return if current_user.admin

      render_response(401, 'You are not authorized to access this resource', :unauthorized, nil)
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:title, :description, :price, :stock, images: [])
    end
  end
end
