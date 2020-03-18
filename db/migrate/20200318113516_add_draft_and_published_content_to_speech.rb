class AddDraftAndPublishedContentToSpeech < ActiveRecord::Migration[5.1]
  def change
    add_column :speeches, :draft, :boolean, :default => false
    add_column :speeches, :published_content, :text
    add_column :speeches, :published, :boolean, :default => false
  end
end
