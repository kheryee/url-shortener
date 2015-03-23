class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :long_url, :short_url
      t.belongs_to :user
    end
  end
end




