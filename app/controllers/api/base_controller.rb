module Api
	class BaseController < ApplicationController
	  before_action :authienticate_with_user_token
	  before_action :get_association_name
		before_action :set_resource, only: [:show, :update, :destroy]
	  # skip_before_filter :verify_authenticity_token, only: [:create, :update, :destroy]
    # skip_before_filter :authenticate_user!
    # skip_before_filter :authienticate_with_user_token


  def authienticate_with_user_token
    token = request.headers[:token].to_s
    user = User.is_authenticated?(token) if token
    if user.present?
      sign_in user, store:false
    else
      respond_to do |format|
        format.json { render json: {errors: [t('api.token.invalid_token')]}, status: 401}
        format.zip {send_data("You are unauthorized", filename: "authentication.txt", status: 401)}
      end
    end
    return user if user   
  end    


	def index
    Rails.logger.info("updated data set")
    @resources = if params[:q] && params[:q].is_a?(Array)
      current_user.send(@association_name).in(_id: params[:q])
    elsif params[:q] && params[:q].is_a?(Hash)
      page = params[:q].delete(:page)
      per = params[:q].delete(:page_size)
      current_user.send(@association_name).search(params[:q]).page(page).per(per)
    else
      @resources = current_user.send(@association_name)
    end
    respond_to do |format|
      if params[:q] && params[:q].is_a?(Hash)
        format.json { render json: {total: @resources.total_count, resources: @resources.as_json(only: @class_name::JsonFields[:only])}, status: :ok }
      else
        format.json { render json: @resources, only: @class_name::JsonFields[:only], status: :ok }
      end
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @resource, except: @class_name::JsonFields[:except], status: :ok }
    end
  end

  def create
    if params[:resource] && params[:resource].is_a?(Hash)
      @resource = current_user.send(@association_name).new(params[:resource].to_hash)
      respond_to do |format|
        if @resource.save
          format.json { render json: @resource, only: @class_name::JsonFields[:only] }
        else
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    elsif params[:resources] && params[:resources].is_a?(Array)
      @resources = current_user.send(@association_name).create(params[:resources].collect(&:to_hash)).select {|res| res.persisted? }
      respond_to do |format|
      	format.json { render json: @resources, only: @class_name::JsonFields[:only], status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: "invalid Structure", status: :unprocessable_entity }
      end
    end
  end

  def update
    if @resource && params[:resource]
      respond_to do |format|
        if @resource.update(params[:resource].to_hash)
          format.json { render json: @resource, only: @class_name::JsonFields[:only], status: :ok }
        else
          format.json { render json: @resource.errors, status: :unprocessable_entity }
        end
      end
    elsif params[:resources]
      @resources = current_user.send(@association_name).update_multiple(params[:resources], {user_id: current_user.id})
      respond_to do |format|
        format.json { render json: @resources, only: @class_name::JsonFields[:only], status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: "invalid Structure", status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if params[:resources]
      @resources = current_user.send(@association_name).in(_id: params[:resources]).to_a
      current_user.send(@association_name).in(_id: params[:resources]).delete

      # @resources = current_user.send(@association_name).in(:_id: params[:resources])
      respond_to do |format|
        format.json { render json: @resources, except: @class_name::JsonFields[:except], status: :ok }
      end
    elsif @resource
      @resource.destroy
      respond_to do |format|
        format.json { render json: @resource, except: @class_name::JsonFields[:except], status: :ok }
      end
    end
  end

  
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      unless @resource = current_user.send(@association_name).find(params[:id])
        respond_to do |format|
          format.json { render json: "#{@class_name} not found", status: :unprocessable_entity  and return}
        end
      end  if params[:id]
    end

    def get_association_name()
      @association_name = params[:controller].split("/").last
      @class_name = @association_name.singularize.classify.constantize
    end
	end
end
