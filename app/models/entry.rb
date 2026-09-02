class Entry < ApplicationRecord
  belongs_to :claim

  after_create_commit :broadcast_created

  private

  def broadcast_created
    broadcast_remove_to stream_name, target: "entries_empty_state"
    broadcast_prepend_to stream_name, target: "entries", partial: "entries/entry", locals: { entry: self, focused: false }
  end

  def stream_name
    "claim_#{claim_id}_entries"
  end
end
