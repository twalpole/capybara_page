# frozen_string_literal: true

module CapybaraPage
  class Waiter
    def self.wait_until_true(wait_time_seconds)
      start_time = Time.now
      loop do
        return true if yield
        break unless Time.now - start_time <= wait_time_seconds
        sleep(0.05)
      end
      raise CapybaraPage::TimeoutException, 'Timed out while waiting for block to return true'
    end
  end
end
