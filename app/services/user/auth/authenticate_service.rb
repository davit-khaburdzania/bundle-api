class User::Auth::AuthenticateService
  def initialize(params)
    @params = params
  end

  def call
    check_param_validness

    @user = find_user_by_auth_provider
    @user = authorize_user if can_be_authorized?

    set_auth_token if token_can_be_set?

    @user
  end

private

  def can_be_authorized?
    # @user.blank? && email_provided?
    @user.blank?
  end

  def token_can_be_set?
    @user.present? && @user.token_not_set?
  end

  def authorize_user
    user = User::CreateService.new(@params).call
    User::Auth::CreateService.new(user, @params).call if user.no_errors?
    user
  end

  def set_auth_token
    @user.auth_token = generate_token_for(@user)
    @user.save
  end

  def find_user_by_auth_provider
    AuthProvider.find_by(
      provider: @params[:provider],
      uid: @params[:uid]
    ).try(:user)
  end

  def email_provided?
    @params[:email].present?
  end

  ## TODO: Move this to appropriate place, waiting for ideas(@jani, @davit)
  def check_param_validness
    errors = Hash.new
    errors[:uid] = ['Uid cant be blank'] if @params[:uid].blank?
    errors[:provider] = ['Provider cant be blank'] if @params[:provider].blank?
    # errors[:email] = ['Email can\'t be blank'] if @params[:email].blank?

    raise Exceptions::ValidationError.new(errors) if any_param_blank?
  end

  def any_param_blank?
    # @params[:uid].blank? || @params[:provider].blank? || @params[:email].blank?
    @params[:uid].blank? || @params[:provider].blank?
  end

  def generate_token_for(user)
    loop do
      token = JWT.encode(user.email, DateTime.now.to_s)
      break token unless User.exists?(auth_token: token)
    end
  end
end
