class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :show, :destroy]
  before_action :require_user, except: [:index, :show]
  before_action :require_same_user, only: [:edit, :update, :destroy]
  
  def index
    @articles = Article.paginate(page: params[:page], per_page: 10)
    @user = current_user
  end
    
  def new
    @article = Article.new
    @user = User.new
  end
  
  def edit
    @user = current_user
  end
  
  def create
     @article = Article.new(article_params)
     @article.user = current_user
    if @article.save
      flash[:success] =  "Article was successfully created!!!"
      redirect_to article_path(@article)
    else 
      render 'new'
    end
  end
  
  def update
    @user = current_user
    if @article.update(article_params)
      flash["success"] = "Article was successfully updated!!!"
      redirect_to article_path(@article)
    else
      render 'edit'
    end
  end
  
  def show
    @user = current_user
  end
  
  def destroy
    @article.destroy
    flash[:danger] = "Article was DESTROYED!!!"
    redirect_to articles_path
  end
  
private
  def set_article
    @article = Article.find(params[:id])
  end
  
  def article_params
    params.require(:article).permit(:title, :description, category_ids: [])    
  end
  
  def require_same_user
    if current_user != @article.user and !current_user.admin?
      flash[:danger] = "You can only edit/delete your own article, silly!!!"
      redirect_to root_path
    end
  end
  
end