class CreateVideos < ActiveRecord::Migration[6.0]
  def change
    create_table :videos do |t|
      t.string :title
      t.string :file_path
      t.belongs_to :season

      t.timestamps
    end
  end
end
