# frozen_string_literal: true

module Cas::Services
  class Validate
    attr_reader :status, :user

    def initialize(service, service_ticket_name)
      @service = service
      @service_ticket_name = service_ticket_name
    end

    def call
      return unless service_found?
      @status = :ok
      @user = @service_ticket.user
    end

    private

    def service_found?
      @service_ticket = ServiceTicket.where(name: @service_ticket_name, service: @service).first
    end
  end
end
