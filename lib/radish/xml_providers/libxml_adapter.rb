module XmlProviders
  module LibXMLAdapter
    
    module_function
    
    def each_xpath(xml, xpath)
      xml = XML::Parser.string(xml).parse if String === xml
      raise TypeError "cannot convert #{xml.class.name} to XML::Node or XML::Document" unless XML::Node === xml or XML::Document === xml
      xml.find(xpath).each { |xml| yield xml }
    end

  end
end

class String
  def each_xpath(xpath)
    XmlProviders::LibXMLAdapter.each_xpath(self, xpath) { |xml| yield xml }
  end
end
