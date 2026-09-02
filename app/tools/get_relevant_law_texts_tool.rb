class GetRelevantLawTextsTool < RubyLLM::Tool
  RESULTS_COUNT = 5

  desc "Search German tenancy law (BGB Mietrecht) for the law texts most relevant to the user's question, " \
       "to ground legal advice in the actual provisions"

  param :query,
        desc: "Search query in formal German describing the legal question or topic, since the law texts are in German"

  def execute(query:)
    vector = RubyLLM.embed(query).vectors
    LawText.nearest_neighbors(:embedding, vector, distance: "cosine")
           .limit(RESULTS_COUNT)
           .map { |law_text| law_text_context(law_text) }
  end

  private

  def law_text_context(law_text)
    law_text.slice(:subtitle, :paragraph_title, :content).symbolize_keys
  end
end
