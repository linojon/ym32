class String
  def capitalize_name
    if self.downcase==self || self.upcase==self
      self.capitalize
    else
      self
    end
  end
  def capitalize_name!
    self.replace self.capitalize_name
  end
  
end
