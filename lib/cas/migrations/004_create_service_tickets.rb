class CreateServiceTickets < ActiveRecord::Migration[4.2]
  def change
    create_table :service_tickets do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
