module ApiDoc2
  class BaseV21ApiDoc < OneboxApiDoc::ApiDoc
    version "2.1.0"

    def_tags do
      tag :web, 'Web', default: true
    end

    def_permissions do
      permission :guest, 'Guest'
    end
  end
end