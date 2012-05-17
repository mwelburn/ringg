class CreateFingers < ActiveRecord::Migration
  def change
    create_table :fingers do |t|
      t.integer :user_id, :null => false
      t.integer :digit, :null => false
      t.integer :side, :null => false
      t.decimal :size, :scale => 2, :default => -1, :null => false
      t.text :comment, :default => ""

      t.timestamps
    end

    add_index :fingers, :user_id
    add_index :fingers, :digit
    add_index :fingers, :size
    add_index :fingers, :side
  end
end
