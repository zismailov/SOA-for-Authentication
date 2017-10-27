# frozen_string_literal: true

class CreateServiceTickets < ActiveRecord::Migration[4.2]
  def change
    create_table :service_tickets do |t|
      t.string :name, null: false
      t.string :service
      t.references :user
      t.timestamps
    end
  end
end
