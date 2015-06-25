module OneboxApiDoc
  class Version < BaseObject
    
    attr_accessor :app_id, :name

    def is_extension?
      app.is_extension?
    end

    def app
      @app ||= OneboxApiDoc.base.apps.detect { |app| app.object_id == self.app_id }
    end

    private

    def set_default_version
      @app = nil
    end
    
  end
end