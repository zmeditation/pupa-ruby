require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Pupa::Processor::Connection::PostgreSQLAdapter do
  include_examples 'SQL adapter', 'postgres://localhost:5432/pupa_test'
end
