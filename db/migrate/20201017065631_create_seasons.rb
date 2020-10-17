class CreateSeasons < ActiveRecord::Migration[6.0]
  def change
    create_table :seasons do |t|
      t.string :title
      t.string :dir_path
      t.belongs_to :show

      t.timestamps
    end
  end
end
