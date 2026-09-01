class CreateLawTexts < ActiveRecord::Migration[8.1]
  def change
    create_table :law_texts do |t|
      t.string :subtitle
      t.string :paragraph_title
      t.text :content
      t.vector :embedding, limit: 1536
      t.index ["embedding"], name: "index_law_texts_on_embedding", using: :hnsw, opclass: :vector_cosine_ops

      t.timestamps
    end
  end
end
