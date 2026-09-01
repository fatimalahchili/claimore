class GetTemplatesTool < RubyLLM::Tool
  desc "Get the available letter templates, their placeholders, and required fields to draft a letter"

  def execute
    Template.all.map { |template| template_context(template) }
  end

  private

  def template_context(template)
    {
      id: template.id,
      name: template.name,
      description: template.description_en,
      instructions: template.instructions_en,
      content: template.content,
      required_fields: template.metadata["required_fields"]
    }
  end
end
