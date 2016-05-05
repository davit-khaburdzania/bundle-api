class User::Auth::CreateService
  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    create_auth_provider if @user.present?
  end

private

  def create_auth_provider
    auth = AuthProvider.create(
      user: @user,
      provider: @params[:provider],
      uid: @params[:uid]
    )

    if auth.any_errors?
      raise Exceptions::ValidationError.new(auth.errors)
    else
      auth
    end
  end

end
