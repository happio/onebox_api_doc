module OneboxApiDoc
  module Annoucements
    class Api < Annoucement
      attr_accessor :api_id

      def message
        "Annoucements::Api"
      end

      def api
        @api ||= doc.apis.detect { |api| api.object_id == api_id }
      end
    end
  end

end