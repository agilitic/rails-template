module ErrorMessagesHelper
  def error_messages(model)
    unless model.nil? || model.errors.empty?
      errors = model.errors.collect do |att, msgs|
        msgs.collect do
           |m| content_tag(:li, m)
        end
      end
    content_tag(:ul, errors.flatten , :class => 'errorExplanation')
    end
  end
end