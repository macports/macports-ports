require "rubygems"

PLUGIN   = "ncurses"
NAME     = "ncurses"
VERSION  = "1.2.3"
AUTHOR   = "Tobias Peters"
EMAIL    = "t-peters@users.berlios.de"
HOMEPAGE = "http://ncurses-ruby.berlios.de/"
SUMMARY  = "This wrapper provides access to the functions, macros, global variables and constants of the ncurses library.  These are mapped to a Ruby Module named \"Ncurses\":  Functions and external variables are implemented as singleton functions of the Module Ncurses."

spec = Gem::Specification.new do |s|
  s.name          = NAME
  s.email         = EMAIL
  s.author        = AUTHOR
  s.version       = VERSION
  s.summary       = SUMMARY
  s.platform      = Gem::Platform::RUBY
  s.has_rdoc      = false
  s.homepage      = HOMEPAGE
  s.description   = SUMMARY
  s.autorequire   = PLUGIN
  s.require_paths = ["lib"]
  s.files = Dir.glob("[A-Z]*") + Dir.glob("*.{c,h,rb}") + Dir.glob("{examples,lib}/**/*")
  s.extensions    = "extconf.rb"
end
