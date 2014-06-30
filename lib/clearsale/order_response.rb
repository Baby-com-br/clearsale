module Clearsale
  class OrderResponse
    STATUS_MAP = {
      "APA" => :automatic_approval,
      "APM" => :manual_approval,
      "RPM" => :rejected_without_suspicion,
      "AMA" => :manual_analysis,
      "ERR" => :error,
      "NVO" => :waiting,
      "SUS" => :manual_rejection,
      "CAN" => :cancelled,
      "FRD" => :fraud,
    }

    attr_reader :order_id, :status, :score

    def self.build_from_send_order(package)
      new(package.fetch(:package_status, {}))
    end

    def self.build_from_update(package)
      new(package.fetch(:clear_sale, {}))
    end

    def initialize(hash)
      response = hash.fetch(:orders, {}).fetch(:order, {})

      if response.blank?
        @status = :inexistent_order
      else
        @order_id = response[:id].gsub(/[a-zA-Z]*/, '').to_i
        @score    = response[:score].to_f
        @status   = STATUS_MAP[response[:status]]
      end
    end

    def approved?
      @status == :automatic_approval || @status == :manual_approval
    end

    def rejected?
      @status == :rejected_without_suspicion || @status == :manual_rejection || @status == :cancelled
    end

    def fraud?
      @status == :fraud
    end

    def manual_analysis?
      @status == :manual_analysis
    end

    def inexistent_order?
      @status == :inexistent_order
    end
  end
end
