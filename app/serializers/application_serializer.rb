class ApplicationSerializer
    include JSONAPI::Serializer
  
    def to_h
      data = serializable_hash
  
      if data[:data].is_a? Hash
        data[:data][:attributes]
  
      elsif data[:data].is_a? Array
        data[:data].map{ |x| x[:attributes] }
  
      elsif data[:data] == nil
        nil
  
      else
        data
      end
    end

    ## Active it if you want to use has_one, has_many and belongs_to
  
    # class << self
    #   def has_one resource, options={}
    #     serializer = options[:serializer] || "#{resource.to_s.classify}Serializer".constantize
  
    #     attribute resource do |object|
    #       serializer.new(object.try(resource)).to_h
    #     end
    #   end
  
    #   def has_many resources, options={}
    #     serializer = options[:serializer] || "#{resources.to_s.classify}Serializer".constantize
  
    #     attribute resources do |object|
    #       serializer.new(object.try(resources)).to_h
    #     end
    #   end

    #   def belongs_to resource, options={}
    #     serializer = options[:serializer] || "#{resource.to_s.classify}Serializer".constantize

    #     attribute resource do |object|
    #       serializer.new(object.try(resource)).to_h
    #     end
    #   end

    # end
end