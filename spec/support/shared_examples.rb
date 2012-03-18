shared_examples_for "a proper name" do |obj, atr|
  it "must be alphabetic" do
    %w{ 1 $ % + }.each do |ch| 
      obj.send("#{atr}=", ch)
      obj.should_not be_valid
    end
  end
  it "allows hyphenation, apostrophe, spaces" do
    obj.send("#{atr}=", "O'a-b c")
    obj.should be_valid
  end
  it "before save, corrects capitalization when all upper or all lower, otherwise leaves it alone" do
    obj.send("#{atr}=", 'cohen')
    obj.save
    obj.send(atr).should == 'Cohen'
    
    obj.send("#{atr}=", 'COHEN')
    obj.save
    obj.send(atr).should == 'Cohen'
    
    obj.send("#{atr}=", 'mcCohen')
    obj.save
    obj.send(atr).should == 'mcCohen'
  end
  it "before save, strips blanks" do
    obj.send("#{atr}=", '  Co hen  ')
    obj.save
    obj.send(atr).should == 'Co hen'
  end
end
