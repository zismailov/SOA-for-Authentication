require "active_record"

class TicketGrantingTicket < ActiveRecord::Base
  belongs_to :user
end
