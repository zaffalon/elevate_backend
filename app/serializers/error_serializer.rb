module ErrorSerializer
    def ErrorSerializer.serialize(errors)
      return if errors.nil?

      new_hash = errors.to_hash(true).map do |k, v|
        v.map do |msg|
          { attribute: k, message: msg }
        end
      end
      return new_hash.flatten
    end
end