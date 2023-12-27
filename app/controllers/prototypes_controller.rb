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
    @prototype = current_user.prototypes.build(prototype_params)
    if @prototype.save
      redirect_to root_path
    else
      # 保存が失敗した場合の処理
      Rails.logger.error @prototype.errors.full_messages.join(', ')
      render :new
    end
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
      redirect_to root_path
  end

  def edit
    @prototype = Prototype.find(params[:id])
  
    unless current_user == @prototype.user
      redirect_to root_path, alert: '他のユーザーのプロトタイプは編集できません。'
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to @prototype, notice: 'プロトタイプが更新されました。'
    else
      flash[:alert] = '更新に失敗しました。エラーを確認してください。'
      render :edit
    end
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def move_to_index
    unless user_signed_in?
      redirect_to action: :index
    end
  end
end

