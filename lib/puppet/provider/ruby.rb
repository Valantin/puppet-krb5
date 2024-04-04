# frozen_string_literal: true

Puppet::Type.type(:krb5_config).provide(ruby) do
  def self.namevar(section_name, setting)
    setting.nil? ? section_name : "#{section_name}/#{setting}"
  end

  def exists?
    if setting.nil?
      ini_file.section_names.include?(section)
    elsif ini_file.section?(section)
      !ini_file.get_value(section, setting).nil?
    elsif resource.parameters.key?(:force_new_section_creation) && !resource[:force_new_section_creation]
      # for backwards compatibility, if a user is using their own ini_setting
      # types but does not have this parameter, we need to fall back to the
      # previous functionality which was to create the section.  Anyone
      # wishing to leverage this setting must define it in their provider
      # type. See comments on
      # https://github.com/puppetlabs/puppetlabs-inifile/pull/286
      resource[:ensure] = :absent
      resource[:force_new_section_creation]
    elsif resource.parameters.key?(:force_new_section_creation) && resource[:force_new_section_creation]
      !resource[:force_new_section_creation]
    else
      false
    end
  end

  def create
    if setting.nil? && resource[:value].nil?
      conf_file.set_value(section)
    else
      conf_file.set_value(section, setting, resource[:value])
    end
    ini_file.save
    @ini_file = nil
  end

  def destroy
    ini_file.remove_setting(section, setting)
    ini_file.save
    @ini_file = nil
  end

  def value
    ini_file.get_value(section, setting)
  end

  def value=(_value)
    if setting.nil? && resource[:value].nil?
      ini_file.set_value(section)
    else
      ini_file.set_value(section, setting, separator, resource[:value])
    end
    ini_file.save
  end

  def section
    # this method is here so that it can be overridden by a child provider
    resource[:section]
  end

  def setting
    # this method is here so that it can be overridden by a child provider
    resource[:setting]
  end

  def file_path
    # this method is here to support purging and sub-classing.
    # if a user creates a type and subclasses our provider and provides a
    # 'file_path' method, then they don't have to specify the
    # path as a parameter for every ini_setting declaration.
    # This implementation allows us to support that while still
    # falling back to the parameter value when necessary.
    if self.class.respond_to?(:file_path)
      self.class.file_path
    else
      resource[:path]
    end
  end
end
