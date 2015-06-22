module OneboxApiDoc
  class BaseObject
    
    include ActiveRecord::AttributeAssignment

    def initialize *attrs
      attrs.map { |hash| hash.transform_values! { |x| x.to_s } }
      assign_attributes(*attrs)
      set_default_value
    end

    private

    def set_default_value
    end
  end
end