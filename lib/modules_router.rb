class ModulesRouter < YARD::Server::Router
  def docs_prefix; 'modules' end
  def list_prefix; 'list/modules' end
  def search_prefix; 'search/modules' end
  def static_prefix; 'static/modules' end
end
