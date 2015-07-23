module Puppet::Parser::Functions

  # TODO: documentation
  newfunction(:kallithea_config_hash_to_inifile_resources, :type => :rvalue) do |args|
    # TODO: do some data validation on config_hash:
    #   * must be a hash of strings, whose values are string-valued hashes of strings
    config_hash = args[0]
    result = {}

    config_hash.each_key do |section|
      config_hash[section].each_key do |setting|
        result["#{section}/#{setting}"] = {
          'ensure'  => 'present',
          'section' => section.to_s,
          'setting' => setting.to_s,
          'value'   => config_hash[section][setting].to_s,
        }
      end
    end

    return result
  end

end

