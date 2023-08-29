class AddMarketToVendors < ActiveRecord::Migration[7.0]
  def change
    add_reference :vendors, :market, null: false, foreign_key: true
  end
end
