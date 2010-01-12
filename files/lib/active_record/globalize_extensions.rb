module ActiveRecord
  module GlobalizeExtensions
    def self.included(base)
      base.extend(ClassMethods)
    end
  
    module ClassMethods
      
      available_locales = I18n.available_locales - [:root]
      empty_hash_for_locales = {}
      
      available_locales.each do |l|
        empty_hash_for_locales[l.to_s] = {} 
      end
      
      def has_translated_attributes
        globalize_options[:translated_attributes].each do |attribute|
          available_locales.each do |locale|
            define_method "#{attribute}_#{locale}" do
              if @translated_attributes_to_save && @translated_attributes_to_save["#{locale}"]["#{attribute}"]
                if @translated_attributes_to_save["#{locale}"]["#{attribute}"].blank?
                  return nil
                else
                  return @translated_attributes_to_save["#{locale}"]["#{attribute}"]
                end
              else
                translation = globalize_translations.first(:conditions => ["locale =  '#{locale}'"])
                unless translation.nil? || translation.send("#{attribute}").blank?
                  return translation.send("#{attribute}")
                else
                  return nil
                end
              end
            end

            define_method "#{attribute}_#{locale}=" do |value|
              unless @translated_attributes_to_save
                @translated_attributes_to_save = empty_hash_for_locales
              end
              @translated_attributes_to_save["#{locale}"]["#{attribute}"] = "#{value}"
            end
            
            # To be called as a callback after save
            define_method "save_translated_attributes" do
              if @translated_attributes_to_save
                set_translations(@translated_attributes_to_save)
                @translated_attributes_to_save = empty_hash_for_locales
              end
            end
          end
        end
        after_save :save_translated_attributes
      end
    end
    
    def translated?(attribute, locale)
      !self.send("#{attribute}_#{locale}").blank?
    end
  end
end