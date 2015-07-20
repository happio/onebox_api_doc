class BaseV1ApiDoc < OneboxApiDoc::ApiDoc
  version "1.0.0"

  def_tags do
    tag :mobile, 'Mobile'
    tag :web, 'Web', default: true
  end

  def_permissions do
    permission :admin, 'Admin'
    permission :member, 'Member'
    permission :guest, 'Guest'
  end
end