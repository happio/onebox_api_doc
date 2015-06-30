module OneboxApiDoc
  module Annoucements
    class Param < Annoucement
      attr_accessor :param_id

      def message
        param.warning
      end

      def param
        @param ||= doc.params.detect { |param| param.object_id == param_id }
      end

      def api
        @api ||= param.api
      end
    end
  end
end