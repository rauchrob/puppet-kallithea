require 'yaml'

settings_file = '/etc/kallithea.yml'

if File.exists? settings_file
  data = YAML.load_file(settings_file)
  if data['metadata_version'] == '1'
    venv = data['default']['venv']
    pip = "#{venv}/bin/pip"
    if File.exists? pip
      Facter.add('kallithea_version') do
        setcode do
          Facter::Core::Execution.exec("#{venv}/bin/pip show kallithea").match(/^Version: (.*)/)[1]
        end
      end
    end
  end
end

