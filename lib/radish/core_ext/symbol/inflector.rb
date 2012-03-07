class Symbol
  
  def pluralize
    Inflector.pluralize(to_s)
  end
  
  def singularize
    Inflector.singularize(to_s)
  end
  
  def camelize(first_letter = :upper)
    case first_letter
      when :upper then Inflector.camelize(to_s, true)
      when :lower then Inflector.camelize(to_s, false)
    end
  end
  alias_method :camelcase, :camelize
  
  def titleize
    Inflector.titleize(to_s)
  end
  alias_method :titlecase, :titleize
  
  def underscore
    Inflector.underscore(to_s)
  end
  
  def dasherize
    Inflector.dasherize(to_s)
  end
  
  def demodulize
    Inflector.demodulize(to_s)
  end
  
  def tableize
    Inflector.tableize(to_s)
  end
  
  def classify
    Inflector.classify(to_s)
  end
  
  def humanize
    Inflector.humanize(to_s)
  end
  
  def foreign_key(separate_class_name_and_id_with_underscore = true)
    Inflector.foreign_key(to_s, separate_class_name_and_id_with_underscore)
  end
  
  def constantize
    Inflector.constantize(to_s)
  end
end
