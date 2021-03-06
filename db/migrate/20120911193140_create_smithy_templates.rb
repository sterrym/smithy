class CreateSmithyTemplates < ActiveRecord::Migration
  def change
    create_table :smithy_templates do |t|
      t.string :name
      t.string :template_type, :default => "template"
      t.text :content

      t.timestamps
    end
  end
end
