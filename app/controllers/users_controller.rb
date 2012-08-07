#!/bin/env ruby
# encoding: utf-8'
class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :destroy, :following, :followers]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def new
  	@user = User.new
  end

  def show
  	 @user = User.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      #UserMailer.signup_confirmation(@user).deliver
      sign_in @user
      flash[:success] = "Добро пожаловать!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
  end

  def index
    if params[:search] 
      @users = User.search(params[:search])
      #@users = User.text_search(params[:query])
      
    else  
      @users = User.paginate(page: params[:page]).per_page(15)
    end  
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Страница изменена."
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "Пользователь удален."
    redirect_to users_path
  end

  def following
    @title = ""
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end 
end
