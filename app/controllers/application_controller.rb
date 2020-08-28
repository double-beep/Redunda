class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  Role.global_role_names.each do |role|
    define_method "verify_#{role}" do
      raise ActionController::RoutingError, 'Not Found' unless current_user&.has_role?(role)
    end
  end
end
