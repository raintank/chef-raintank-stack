package "xvfb"
package "qt4-qmake"
package "libqtwebkit-dev"
package "g++"

%w(gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x).each do |pkg|
  package pkg
end
