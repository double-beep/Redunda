class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable

  def after_database_authentication
    Thread.new do
      begin
        update(username: get_username(nil, stack_exchange_account_id))
      rescue StandardError
        nil
      end
    end
  end

  def get_username(readonly_api_token, network_user_id = nil)
    config = AppConfig['stack_exchange']

    if network_user_id.present?
      find_username_from_url(network_user_id)
    else
      auth_string = "key=#{config['key']}&access_token=#{readonly_api_token || api_token}"
      network_id = JSON.parse(Net::HTTP.get_response(URI.parse("https://api.stackexchange.com/2.2/me/associated?#{auth_string}")).body)
      find_username_from_url(network_id['items'][0]['account_id'])
    end
  rescue StandardError
    nil
  end

  def find_username_from_url(network_user_id)
    Net::HTTP.get_response(URI.parse("https://stackexchange.com/users/#{network_user_id}"))['location'].split('/')[3]
  end

  Role.global_role_names.each do |role|
    define_method "is_#{role}?" do
      has_role?(role)
    end
  end

  Role.scoped_roles.each do |role, resource|
    define_method "is_#{role}?" do |res_arg|
      res_arg.is_a?(resource) && has_role?(role, res_arg)
    end
  end
end
