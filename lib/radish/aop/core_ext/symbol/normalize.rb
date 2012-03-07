class Symbol
  def normalize
    to_s.gsub(/\W/, '_').to_sym
  end
end
