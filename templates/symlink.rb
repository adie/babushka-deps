meta :symlink do
  accepts_value_for :source
  accepts_value_for :destination
  accepts_value_for :sudo, false
  template do
    met? { destination.p.readlink == source.p }
    meet { shell "ln -sf #{source} #{destination}", :sudo => sudo }
  end
end
