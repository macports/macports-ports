#!/usr/bin/env ruby
# $Id$
# upgrade all Portfiles of Ruby-GNOME2 modules; rb-glib2, rb-gtk2, ..
# [usage] port-upd-rb-gnome.rb tarball-path
#

require 'openssl'

# target Portfiles of Ruby/Gnome2 modules
PORTFILES =
	# meta package
	%w[rb-gnome] +
	# gtk
	%w[rb-glib2 rb-atk rb-pango rb-gtk2] +
	# gnome modules
	%w[rb-rsvg rb-poppler rb-vte rb-gtksourceview2] +
	# experimental
	%w[rb-gstreamer]
	# deprecated: after 1.0.0, the bellow modules are not contained
	#             source tree of ruby-gnome2. these ports will not
	#             be updated.
	#%w[rb-gconf rb-libgnome rb-gnomecanvas rb-gnomeprint rb-gnomeprintui
	#   rb-gnomevfs rb-gtkhtml rb-gtkglext rb-libglade3 rb-libart]
# no ports: gio2 - no port for Gnome GIO
# deprecated and no ports: GtkMozeEmbed, GtkSourceView, PanelApplet

class App

  attr_accessor :version, :sums

  def initialize(version, tarball)
    self.version = version
    self.sums = checksums(tarball)
    puts <<EOS
######
input file: #{tarball}
ruby-gnome: #{self.version}
checksums md5: #{self.sums.md5}
	  sha1: #{self.sums.sha1}
	  rmd160: #{self.sums.rmd160}
######
EOS
  end

  def run
    PORTFILES.each do |port|
      update(port)
      puts "update #{port}"
    end
  end

  Checksums = Struct.new(:md5, :sha1, :rmd160)

  private

  def checksums(path)
    bytes = File.read(path)
    sums = Checksums.new
    sums.md5 = OpenSSL::Digest::MD5.new(bytes).hexdigest
    sums.sha1 = OpenSSL::Digest::SHA1.new(bytes).hexdigest
    sums.rmd160 = OpenSSL::Digest::RIPEMD160.new(bytes).hexdigest
    return sums
  end

  def update(port)
    path = File.join('ruby', port, 'Portfile')
    text = File.read(path)
    # update version at ruby.setup
    text[/ruby.setup\s+\{.*\}\s+(\S+)\s+(extconf\.rb|fetch)/m, 1] = self.version
    # update checksums {md5/sha1/rmd160}
    self.sums.each_pair do |type, sum|
      text[/\s+#{type}\s+([0-9a-f]+)/, 1] = sum
    end

    ## add fetch from svn trunk
    svn_tag = self.version[/\.r(\d+)/, 1]
    if svn_tag
      update_svn(text, svn_tag)
    else
      remove_svn_cmds(text)
    end
    File.open(path, 'w') {|f| f.write(text)}
  end

  FETCH_RE = /^(fetch\s+\{.*\}\s*\n)/m
  WORKSRCDIR_RE = /^worksrcdir\s+(\S+)\n/m

  def update_svn(text, svn_tag)
    fetch_cmd = <<FETCH_CMD
fetch { 
  if {[file isfile \${distpath}/\${distname}\${extract.suffix}]} {return 0}
  curl fetch "http://ruby-gnome2.svn.sourceforge.net/viewvc/ruby-gnome2/ruby-gnome2/trunk.tar.gz?view=tar&pathrev=#{svn_tag}" \${distpath}/\${distname}\${extract.suffix}
}
FETCH_CMD
    begin
      text[FETCH_RE, 1] = fetch_cmd
    rescue IndexError
      text << fetch_cmd
    end
    worksrcdir = 'trunk'
    begin
      text[WORKSRCDIR_RE, 1] = worksrcdir
    rescue IndexError
      text << "worksrcdir #{worksrcdir}\n"
    end
  end

  def remove_svn_cmds(text)
    text.sub!(FETCH_RE, '')
    text.sub!(WORKSRCDIR_RE, '')
  end
end

if ARGV.size != 1
  $stderr.puts "[usage] port-upd-rb-gnome.rb tarball-file"
  exit 1
end

tarball = ARGV.shift
vers = tarball.slice(/ruby-gnome2-(?:all-)?(\S+).tar.gz/, 1)

App.new(vers, tarball).run

