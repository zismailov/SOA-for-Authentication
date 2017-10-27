# frozen_string_literal: true

require 'active_record'

class ServiceTicket < ActiveRecord::Base
  belongs_to :user
end
