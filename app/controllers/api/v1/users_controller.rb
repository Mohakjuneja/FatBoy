module Api
  module V1
    class UsersController < Api::BaseController

    skip_before_filter :verify_authenticity_token, only: [ :forgot_password]
    skip_before_filter :authenticate_user!, only: [ :forgot_password]
    skip_before_filter :authienticate_with_user_token, only: [ :forgot_password]

    respond_to :json
  
    before_action :set_user, only: [:show, :destroy]

    def create
      if params[:resource] && params[:resource].is_a?(Hash)
        @resource = User.new(params[:resource].to_hash)
        respond_to do |format|
          if @resource.save
            format.json { render :json => { :user => @resource,
              :status => :ok,
              :message => "Registration successfully done",
              :type => 'success',
              }}
          else
            format.json { render json: @resource.errors, status: :unprocessable_entity }
          end
        end      
      elsif params[:resources] && params[:resources].is_a?(Array)
        @resources = User.create(params[:resources].collect(&:to_hash)).select {|res| res.persisted? }
        respond_to do |format|
          format.json { render json: @resources, only: [:_id, :email, :phone,:name], status: :ok }
        end
      else
        respond_to do |format|
          format.json { render json: "invalid Structure", status: :unprocessable_entity }
        end
      end
    end

  
    def forgot_password
      user = User.where(:email => params['email'].downcase).first
      if user
        user.send_reset_password_instructions
        respond_to do |format|
          format.json {
            render :json => {
              :status => :ok, 
              :type => 'success',
              :message => "Link to reset the password has been sent to the registered email address"
            }
          }
        end
      else
        respond_to do |format|
          format.json {
            render :json => {
              :status => :ok,
              :type => 'failure',
              :message => "Invalid Username/Password"
            }
          }
        end
      end
    end


  def set_user
    @user = User.find(params[:id])    
  end
  
  def user_params
    params.require(:user).permit(:email, :mobile_number, :password, :password_confirmation)
  end

end
end
end