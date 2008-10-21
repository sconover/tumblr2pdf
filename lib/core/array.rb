class Array

  def pluck(*getter_symbols)
    raise "need at least one symbol" unless getter_symbols.length >= 1

    results = collect do |item|

      getter_symbols.collect do |getter_symbol|

        traversal_instructions = getter_symbol.is_a?(Array) ? getter_symbol : [getter_symbol]  

        thing = item
        traversal_instructions.each do |element|
          thing = thing.is_a?(Hash) ? thing[element] : thing.send(element)
        end

        thing

      end
    end

    if getter_symbols.length == 1
      results.flatten
    else
      results
    end
  end
  
end