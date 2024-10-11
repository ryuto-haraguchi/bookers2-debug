class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only:[:show, :edit, :update]
  before_action :ensure_owner, only:[:edit, :update]


  def index
    @groups = Group.all
  end

  def show
  end

  def edit
  end

  def update
    if @group.updeta(group_params)
      flash[:notice] = "Group was successfully updated."
      redirect_to @group
    else
      render :edit
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.build(group_params)
    if @group.save
      flash[:notice] = "Group was successfully created."
      redirect_to groups_path
    else
      render :new
    end
  end

  private

  def group_params
    params.require(:group).permit(:name, :introduction, :group_image)
  end

  def set_group
    @group = Group.find(params[:id])
  end

  def ensure_owner
    redirect_to group_path, alert: "You are not authorized to edit this group." unless @group.owner == current_user
  end

end
