class User::RegistrationsController < Devise::RegistrationsController
before_filter :configure_permitted_parameters

protected

def configure_permitted_parameters
  devise_parameter_sanitizer.permit(:sign_up, keys: [:fname, :lname])
  devise_parameter_sanitizer.permit(:account_update, keys: [:fname, :lname])
end

end

