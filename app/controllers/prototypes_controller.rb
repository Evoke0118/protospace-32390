class PrototypesController < ApplicationController
 
before_action :authenticate_user!, only: [:new, :edit, :destroy]
before_action :move_to_index, except: [:index, :show]


  def index
    @prototypes = Prototype.all
  end

  def new
    @prototype = Prototype.new
  end

  def create
    @prototype = Prototype.create(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])      
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)  #ネストの関係を利用 #userモデルとcommentを紐づけている
  end

  def edit
    @prototype = Prototype.find(params[:id])      
  end

  def update
    @prototype = Prototype.find(params[:id])      #間違えた内容▶︎ @prototype = Prototype.update(prototype_params)
    if @prototype.update(prototype_params)
      redirect_to prototype_path
    else
      render :edit
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path  #削除出来なかった場合とかの条件分岐はここではいらん
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image ).merge(user_id: current_user.id)
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end

end
  
