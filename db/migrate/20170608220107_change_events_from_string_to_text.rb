class ChangeEventsFromStringToText < ActiveRecord::Migration[5.1]
  def up
    change_column :events, :headers, :text
    change_column :events, :content, :text
  end

  def down
    change_column :events, :headers, :string
    change_column :events, :content, :string
  end
end
