require "onebox_api_doc/base"

module OneboxApiDoc

  def self.base
    @application ||= OneboxApiDoc::Base.new
  end

end