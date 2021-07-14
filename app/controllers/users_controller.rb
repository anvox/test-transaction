class UsersController < ApplicationController
  # before_action :set_user, only: %i[ show edit update destroy ]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # TEST 1:
  # Run /trans?name=Trans
  # Run /done?name=Done while 1st sleep
  # Expect: Sidekiq will run with name=Done
  # TEST 2:
  # Run /trans?name=Trans
  # Run /done?name=Done while 2st sleep
  # Expect: Sidekiq will run with name=Done
  def trans
    ActiveRecord::Base.transaction do
      user = User.create!(name: params[:name].to_s)
      sleep(5) # User.create from /users/done
      PlayInBackground.perform_async(user.id)
      sleep(5) # User.create from /users/done
      raise ActiveRecord::Rollback, "Revert the world!!!"
    end
  end

  def done
    User.create!(name: params[:name].to_s)

    respond_to do |format|
      format.html { render :trans }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:name, :email, :age)
    end
end
