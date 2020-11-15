class ListenersController < ApplicationController
  before_action :set_listener, only: [:show, :edit, :update, :destroy]

  # GET /listeners
  # GET /listeners.json
  def index
    @listeners = Listener.all
  end

  # GET /listeners/1
  # GET /listeners/1.json
  def show
  end

  # GET /listeners/new
  def new
    @listener = Listener.new
  end

  # GET /listeners/1/edit
  def edit
  end

  # POST /listeners
  # POST /listeners.json
  def create
    @listener = Listener.new(listener_params)

    respond_to do |format|
      if @listener.save
        format.html { redirect_to @listener, notice: 'Listener was successfully created.' }
        format.json { render :show, status: :created, location: @listener }
      else
        format.html { render :new }
        format.json { render json: @listener.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /listeners/1
  # PATCH/PUT /listeners/1.json
  def update
    respond_to do |format|
      if @listener.update(listener_params)
        format.html { redirect_to @listener, notice: 'Listener was successfully updated.' }
        format.json { render :show, status: :ok, location: @listener }
      else
        format.html { render :edit }
        format.json { render json: @listener.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /listeners/1
  # DELETE /listeners/1.json
  def destroy
    @listener.destroy
    respond_to do |format|
      format.html { redirect_to listeners_url, notice: 'Listener was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_listener
      @listener = Listener.find_by_hashid(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def listener_params
      params.require(:listener).permit(:user_id, :group_name, :group_code, :group_title, :group_description)
    end
end
