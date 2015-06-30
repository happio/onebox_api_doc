module OneboxApiDoc
  class BaseObject
    
    include ActiveRecord::AttributeAssignment

    def initialize *attrs, &block
      attrs.map { |hash| hash.transform_values! { |value| value.is_a?(Symbol)? value.to_s : value } }
      assign_attributes(*attrs)
      set_default_value
    end

    private

    def set_default_value
    end
  end
end