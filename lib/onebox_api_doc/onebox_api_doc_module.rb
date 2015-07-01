require "onebox_api_doc/base"

module OneboxApiDoc

  def self.base
    @application ||= OneboxApiDoc::Base.new
  end

  def self.reset
    @application = OneboxApiDoc::Base.new
  end

end