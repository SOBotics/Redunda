class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  Role.global_role_names.each do |role|
    define_method "verify_#{role}" do
      unless current_user&.has_role?(role)
        raise ActionController::RoutingError.new('Not Found')
      end
    end
  end
end
