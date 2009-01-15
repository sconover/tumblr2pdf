class Object
  def setup_named_params(args, defaults, required=[])
    allowed_keys = defaults.keys + required
    unless (invalid_keys = args.keys - allowed_keys).empty?
      raise "args contain keys not in defaults.\nargs not allowed:#{invalid_keys.join(",")}\nallowed:#{defaults.keys.join(",")}"
    end
    
    unless (missing_keys = required - args.keys).empty?
      raise "some required args not passed in.\nmissing:#{missing_keys.join(",")}\nrequired:#{required.join(",")}"
    end
        
    self.class.send(:attr_reader, *allowed_keys)
    
    merged = defaults.merge(args)
    
    merged.each do |arg_symbol, value|
      instance_variable_set("@#{arg_symbol.to_s}".to_sym, value)
    end
  end

end