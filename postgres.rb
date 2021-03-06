dep 'postgres.managed', :version, :locale_name do
  version.default('9.2')
  locale_name.default!('en_US')
  # Assume the installed version if there is one
  version.default!(shell('psql --version').val_for('psql (PostgreSQL)')[/^\d\.\d/]) if which('psql')
  requires 'set.locale'.with(locale_name)
  installs {
    via :apt, ["postgresql-#{owner.version}", "libpq-dev"]
    via :brew, "postgresql"
  }
  provides "psql ~> #{version}.0"
end
