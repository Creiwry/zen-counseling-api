class AddTypeToAppointments < ActiveRecord::Migration[7.1]
  def change
    add_column :appointments, :appointment_type, :string
  end
end
