require 'ipaddr'

class AuthorizedIps
  AUTHORIZED_IP_ADDRESSES = ENV['AUTHORIZED_IP_ADDRESSES'] ? eval(ENV['AUTHORIZED_IP_ADDRESSES']) : {}

  def self.authorized_ip?(address)
    AUTHORIZED_IP_ADDRESSES.each_value.to_a.flatten.any? { |block| block.include?(address) }
  end

  def self.corresponding_ip_key(address)
    matching_standup = nil
    AUTHORIZED_IP_ADDRESSES.each do |standup, ip_list|
      matching_standup = standup.to_s if ip_list.any? {|ip| ip.include?(address)}
    end
    matching_standup
  end

  def self.update_ip (standup, ip)
    if AUTHORIZED_IP_ADDRESSES.has_key?(standup)
      AUTHORIZED_IP_ADDRESSES[standup] = ip
  end

  def self.write_to_env
    if ENV['AUTHORIZED_IP_ADDRESSES'] && AUTHORIZED_IP_ADDRESSES
      ENV['AUTHORIZED_IP_ADDRESSES'] = AUTHORIZED_IP_ADDRESSES
      `heroku config:set AUTHORIZE_IP_ADDRESSES`
    end


  end

  def development?
    @request.env["REMOTE_ADDR"] == "127.0.0.1" && @request.env["HTTP_X_REAL_IP"].to_s == ""
  end
end
