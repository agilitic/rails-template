module ActionView::Helpers::FormHelper 
  # Addition to make the +label+ method use ActiveRecord::Base#human_attribute_name 
  # in order to invoke i18n. 
  def label_with_human_name(object_name, method, text = nil, options = {}) 
    unless text 
      klass = object_name.to_s.classify.constantize rescue nil 
      text = klass.human_attribute_name(method.to_s) if klass 
    end 
    label_without_human_name(object_name, method, text, options) 
  end 
  alias_method_chain :label, :human_name 
end

# Displays the error fields as we want...
ActionView::Base.field_error_proc =  Proc.new do |html_tag, instance|
  if html_tag.index('<label').nil? && html_tag.index('type="hidden"').nil? && html_tag.index('type="checkbox"').nil?
    "#{html_tag}<div class=\"field_validation_messages\"><img src=\"/images/exclamation.png\" alt=\"error\" />&nbsp;#{instance.error_message.to_a.join(', ')}</div>"
  else
    "#{html_tag}"
  end
end