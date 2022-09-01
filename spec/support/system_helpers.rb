# frozen_string_literal: true

module SystemHelpers
  def sign_in(user)
    visit "/session/#{user.encoded_username}/become"
  end

  def setup_system_test
    SiteSetting.login_required = false
    SiteSetting.content_security_policy = false
    SiteSetting.force_hostname = "#{Capybara.server_host}:#{Capybara.server_port}"
    SiteSetting.external_system_avatars_enabled = false
  end

  def wait_for_record(&block)
    record_found = false
    record = nil
    sleep_backoff = 0.01
    start_time = Time.zone.now
    while !record_found
      record = block.call
      record_found = record.present?
      sleep sleep_backoff
      sleep_backoff += 0.01
      if Time.zone.now >= start_time + 3.seconds
        puts "Could not find record in time. Aborting!"
        break
      end
    end
    record
  end
end
