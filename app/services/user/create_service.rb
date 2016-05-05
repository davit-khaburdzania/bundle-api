class User::CreateService
  def initialize(params)
    @params = params
  end

  def call
    @user = find_user_by_email
    @user = create_user if @user.blank?
    @user
  end

private

  def find_user_by_email
    User.find_by(email: @params[:email]) if @params[:email].present?
  end

  def create_user
    user = User.create(
      name: @params[:name],
      email: @params[:email],
      image: @params[:image],
      username: @params[:username]
    )

    if user.any_errors?
      raise Exceptions::ValidationError.new(user.errors)
    else
      user
    end
  end
end
