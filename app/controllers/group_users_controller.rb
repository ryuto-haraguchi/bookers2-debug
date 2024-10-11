class GroupUsersController < ApplicationController
  before_action :set_group

  def create
    if @group.group_users.exists?(user_id: current_user)
      flash[:notice] = "You are already a member of this group."
      redirect_to groups_path
    else
      @group.group_users.create(user: current_user)
      flash[:notice] = "You have successfully joined the group."
      redirect_to groups_path
    end
  end

  def destroy
    group_user = @group.group_users.find_by(user: current_user)
    group_user.destroy
    flash[:notice] = 'You have successfully left the group.'
    redirect_to groups_path
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end
end
