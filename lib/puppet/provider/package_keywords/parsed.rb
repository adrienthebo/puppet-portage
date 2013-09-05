require_relative '../portagefile'
require_relative '../util/portage'

Puppet::Type.type(:package_keywords).provide(:parsed,
  :parent => Puppet::Provider::PortageFile,
  :default_target => "/etc/portage/package.keywords/default",
  :filetype => :flat
) do

  desc "The package_keywords provider that uses the ParsedFile class"

  record_line :parsed, :fields => %w{name keywords}, :joiner => ' ', :rts => true do |line|
    Puppet::Provider::PortageFile.process_line(line, :keywords)
  end

  # Define the ParsedFile format hook
  #
  # @param [Hash] hash
  #
  # @return [String]
  def self.to_line(hash)
    return super unless hash[:record_type] == :parsed
    build_line(hash, :keywords)
  end
end
