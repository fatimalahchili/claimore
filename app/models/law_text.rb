class LawText < ApplicationRecord
  has_neighbors :embedding
  after_create :set_embedding

  private

  def set_embedding
    text = "#{subtitle}. #{paragraph_title}. #{content}"
    embedding = RubyLLM.embed(text)
    update(embedding: embedding.vectors)
  end
end
