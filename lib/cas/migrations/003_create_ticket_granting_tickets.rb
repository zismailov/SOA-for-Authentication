class CreateTicketGrantingTickets < ActiveRecord::Migration[4.2]
  def change
    create_table :ticket_granting_tickets do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
