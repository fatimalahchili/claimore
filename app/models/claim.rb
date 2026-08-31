class Claim < ApplicationRecord
  belongs_to :property

  scope :active, -> { where.not(status: "resolved") }

  has_many :tenants, through: :property
  has_many :letters
  has_many :entries
  has_many :users, through: :tenants
  has_many :chats, dependent: :destroy

  enum :status, { archived: "archived", active: "active" }, default: :active

  def chat_context
    lines = [
      "The user is currently viewing this claim:",
      "- Category: #{category.presence || 'Unspecified'}",
      "- Status: #{status}",
      "- Property: #{property.address}"
    ]

    recent_entries = entries.order(date: :desc, created_at: :desc).limit(5)
    if recent_entries.any?
      lines << "- Recent timeline entries:"
      recent_entries.each do |entry|
        lines << "  - #{entry.date}: #{entry.title} (#{entry.status}) - #{entry.description}"
      end
    end

    recent_letters = letters.order(sent_on: :desc).limit(5)
    if recent_letters.any?
      lines << "- Letters sent:"
      recent_letters.each do |letter|
        lines << "  - #{letter.title} sent #{letter.sent_on}: #{letter.summary}"
      end
    end

    lines.join("\n")
  end
end
