class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]
  # protect_from_forgery with: :exception, prepend: true

  # GET /accounts
  # GET /accounts.json
  # LOGIN PAGE -- SECRETARY GENERAL AND ENCODERS
  def index 
    #@accounts = Account.all 
    redirect_to '/accounts/new'
  end

  # GET /adminsettings
  def admin

  end

  # GET /adminsettings_password
  def passwordchange
    a = Account.find_by_id(0)

    #print params[:c] + "\n" + a.password 
    if params[:c] == a.password
      a.password = params[:n]
      a.save
      session[:adminsettingsnotice] = "Password successfully changed."
    else
      session[:adminsettingsnotice] = "Wrong current password. Password not changed."  
      # print session[:adminsettingserror]
    end

    redirect_to '/adminsettings'
  end

  # GET /adminsettings_username
  def adminchange
    a = Account.find_by_id(0)
    a.username = params[:new]
    a.save

    session[:current] = params[:new]

    session[:adminsettingsnotice] = "Username successfully changed."
    redirect_to '/adminsettings'
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
  end

  # GET /accounts/new
  # SECRETARY GENERAL GENERATES A TOKEN FOR ENCODER LOGINS
  def new 
     if !session[:current].nil?
          redirect_to '/animalprofiles'
     end
    @account = Account.new
  end

  # GET /accounts/1/edit
  # CHANGE USERNAME AND PASSWORD OF SECRETARY GENERAL
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
     if !session[:current].nil?
          redirect_to '/animalprofiles'
     end

    @account = Account.new(account_params)
    @pass = Digest::SHA256.hexdigest(@account.password)

    # check if this is an encoder login
    @tmp = Account.where(username: "encoder").take
    if @tmp.password == @pass   # input password matches the token for encoders
          session[:current] = @account.username
          redirect_to '/animalprofiles'
    else
         @account.username = @account.username.strip
         @id = Account.where(username: @account.username).take
         if @id.nil?
          print "NULL"
           @error = "Wrong username/password."
           redirect_to '/login'

         elsif @id.id = 1
           print "NOT NULL"
           if @pass == @id.password.downcase
             session[:current] = @id.username
             #print session[:current]
             redirect_to '/animalprofiles'
           else
             @error = "Wrong username/password."
             redirect_to '/login'
           end 
         end
     end
    #print @account.username
    # respond_to do |format|
    #   if @account.save
    #     format.html { redirect_to @account, notice: 'Account was successfully created.' }
    #     format.json { render :show, status: :created, location: @account }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @account.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to @account, notice: 'Account was successfully updated.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    # if session[:current] != ''
    #   print "session is not defined"
    # else
    #   print "session is defined"
    #   print session[:current]
    # end

    # session [:current] = ''

    # redirect_to '/viewprofiles'
    #
    # @account.destroy
    # respond_to do |format|
    #   format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:username, :password)
    end
end
