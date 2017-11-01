# frozen_string_literal: true

class CreateTicketGrantingTickets < ActiveRecord::Migration[4.2]
  def change
    create_table :ticket_granting_tickets do |t|
      t.string :name, null: false
      t.references :user
      t.timestamps
    end
  end
end
