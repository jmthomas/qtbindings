# Generates a Makefile that:
# 1. Cleans up the build directory
# 2. Runs cmake to build qtbindings
# 3. Copies the built .so files into the correct places

windows = false
macosx  = false
processor, platform, *rest = RUBY_PLATFORM.split("-")
windows = true if platform =~ /mswin32/ or platform =~ /mingw32/
macosx  = true if platform =~ /darwin/

ruby_version_split = RUBY_VERSION.split('.')
if ruby_version_split[0].to_i == 1
  ruby_version = '1.9'
  if ruby_version_split[1].to_i == 8
    puts "Ruby 1.8.x is no longer supported. Install qtbindings 4.8.3.0. gem install qtbindings -v 4.8.3.0"
    exit
  end
else # Ruby 2.X
  ruby_version = RUBY_VERSION
end

if windows
  # README! - Modify this path if you have QT installed somewhere else
  # or if you have a different version of QT you want to link to.
  qt_sdk_path = "C:\\Qt\\4.8.6"
  begin
    File::Stat.new(qt_sdk_path)
  rescue
    puts "ERROR! QT SDK doesn't exist at #{qt_sdk_path}"
    exit # Not much we can do if the QT SDK doesn't exist
  end
end

File.open('Makefile', 'w') do |file|
  if windows
    file.puts "all: clean build"
    file.puts ""
    file.puts "makedirs:"
    file.puts "\t-mkdir ext\\build"
    file.puts "\t-mkdir bin\\1.9"
    file.puts "\t-mkdir bin\\2.0"
    file.puts "\t-mkdir qtbin\\plugins"
    file.puts "\t-mkdir qtbin\\plugins\\accessible"
    file.puts "\t-mkdir qtbin\\plugins\\bearer"
    file.puts "\t-mkdir qtbin\\plugins\\codecs"
    file.puts "\t-mkdir qtbin\\plugins\\designer"
    file.puts "\t-mkdir qtbin\\plugins\\graphicssystems"
    file.puts "\t-mkdir qtbin\\plugins\\iconengines"
    file.puts "\t-mkdir qtbin\\plugins\\imageformats"
    file.puts "\t-mkdir qtbin\\plugins\\phonon_backend"
    file.puts "\t-mkdir qtbin\\plugins\\qmltooling"
    file.puts "\t-mkdir qtbin\\plugins\\sqldrivers"
    file.puts "\t-mkdir lib\\1.9"
    file.puts "\t-mkdir lib\\2.0"
    file.puts ""
    file.puts "clean: makedirs"
    file.puts "\t-cd ext\\build && rmdir /S /Q CMakeFiles"
    file.puts "\t-cd ext\\build && rmdir /S /Q generator"
    file.puts "\t-cd ext\\build && rmdir /S /Q smoke"
    file.puts "\t-cd ext\\build && rmdir /S /Q ruby"
    file.puts "\t-cd ext\\build && del /F /Q *"
    file.puts ""
    file.puts "distclean: clean"
    file.puts "\t-cd bin && del /F /Q *.dll"
    file.puts "\t-cd bin && del /F /Q *.so"
    file.puts "\t-cd bin && del /F /Q *.exe"
    file.puts "\t-cd qtbin && del /F /Q *.dll"
    file.puts "\t-cd qtbin\\plugins && del /F /Q *"
    file.puts "\t-cd qtbin\\plugins\\accessible && del /F /Q *"
    file.puts "\t-cd qtbin\\plugins\\bearer && del /F /Q *"
    file.puts "\t-cd qtbin\\plugins\\codecs && del /F /Q *"
    file.puts "\t-cd qtbin\\plugins\\designer && del /F /Q *"
    file.puts "\t-cd qtbin\\plugins\\graphicssystems && del /F /Q *"
    file.puts "\t-cd qtbin\\plugins\\iconengines && del /F /Q *"
    file.puts "\t-cd qtbin\\plugins\\imageformats && del /F /Q *"
    file.puts "\t-cd qtbin\\plugins\\phonon_backend && del /F /Q *"
    file.puts "\t-cd qtbin\\plugins\\qmltooling && del /F /Q *"
    file.puts "\t-cd qtbin\\plugins\\sqldrivers && del /F /Q *"
    file.puts "\t-cd bin\\1.9 && del /F /Q *"
    file.puts "\t-cd bin\\2.0 && del /F /Q *"
    file.puts "\t-cd lib\\1.9 && del /F /Q *"
    file.puts "\t-cd lib\\2.0 && del /F /Q *"
    file.puts "\t-del /F /Q Makefile"
    file.puts "\t-del /F /Q qtbindings-*.gem"
    file.puts ""
    file.puts "build: makedirs"
    file.puts "\tset CC=i686-w64-mingw32-gcc.exe"
    file.puts "\tset CXX=i686-w64-mingw32-g++.exe"
    file.puts "\t-cd ext\\build && \\"
    file.puts "cmake \\"
    file.puts "-G \"MinGW Makefiles\" \\"
    if ARGV[0] == '-d'
      file.puts "-DCMAKE_BUILD_TYPE=Debug \\"
    end
    file.puts "-DCMAKE_MAKE_PROGRAM=mingw32-make.exe \\"
    file.puts "-Wno-dev \\"
    file.puts "-DENABLE_SMOKE=on \\"
    file.puts "-DENABLE_QTCORE_SMOKE=on \\"
    file.puts "-DENABLE_QTNETWORK_SMOKE=on \\"
    file.puts "-DENABLE_QTDBUS_SMOKE=off \\"
    file.puts "-DENABLE_QTGUI_SMOKE=on \\"
    file.puts "-DENABLE_QTSVG_SMOKE=on \\"
    file.puts "-DENABLE_QTSQL_SMOKE=on \\"
    file.puts "-DENABLE_QTXML_SMOKE=on \\"
    file.puts "-DENABLE_QTXMLPATTERNS_SMOKE=on \\"
    file.puts "-DENABLE_QTOPENGL_SMOKE=on \\"
    file.puts "-DENABLE_QTWEBKIT_SMOKE=on \\"
    file.puts "-DENABLE_QTSCRIPT_SMOKE=on \\"
    file.puts "-DENABLE_QTUITOOLS_SMOKE=on \\"
    file.puts "-DENABLE_QTTEST_SMOKE=on \\"
    file.puts "-DENABLE_QTMULTIMEDIA_SMOKE=on \\"
    file.puts "-DENABLE_QTRUBY=on \\"
    file.puts "-DENABLE_QTWEBKIT_RUBY=on \\"
    file.puts "-DENABLE_QTUITOOLS_RUBY=on \\"
    file.puts "-DENABLE_QTSCRIPT=on \\"
    file.puts "-DENABLE_QTTEST=on \\"
    file.puts "-DRUBY_EXECUTABLE=#{File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['RUBY_INSTALL_NAME'])} \\"
    file.puts ".."
    file.puts "\tcd ext\\build && mingw32-make"
    file.puts ""
    file.puts "install: makedirs"
    file.puts "\t-copy ext\\build\\smoke\\deptool\\smokedeptool.exe bin\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtcore\\libsmokeqtcore.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtgui\\libsmokeqtgui.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qthelp\\libsmokeqthelp.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtmultimedia\\libsmokeqtmultimedia.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtnetwork\\libsmokeqtnetwork.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtopengl\\libsmokeqtopengl.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtscript\\libsmokeqtscript.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtsql\\libsmokeqtsql.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtsvg\\libsmokeqtsvg.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qttest\\libsmokeqttest.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtuitools\\libsmokeqtuitools.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtwebkit\\libsmokeqtwebkit.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtxml\\libsmokeqtxml.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\qtxmlpatterns\\libsmokeqtxmlpatterns.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\smokeapi\\smokeapi.exe bin\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\smoke\\smokebase\\libsmokebase.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\ruby\\qtruby\\src\\libqtruby4shared.dll lib\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\ruby\\qtruby\\src\\qtruby4.dll lib\\#{ruby_version}\\qtruby4.so"
    file.puts "\t-copy ext\\build\\ruby\\qtscript\\qtscript.dll lib\\#{ruby_version}\\qtscript.so"
    file.puts "\t-copy ext\\build\\ruby\\qttest\\qttest.dll lib\\#{ruby_version}\\qttest.so"
    file.puts "\t-copy ext\\build\\ruby\\qtuitools\\qtuitools.dll lib\\#{ruby_version}\\qtuitools.so"
    file.puts "\t-copy ext\\build\\ruby\\qtwebkit\\qtwebkit.dll lib\\#{ruby_version}\\qtwebkit.so"
    file.puts "\t-copy ext\\build\\ruby\\qtruby\\tools\\rbrcc\\rbrcc.exe bin\\#{ruby_version}"
    file.puts "\t-copy ext\\build\\ruby\\qtruby\\tools\\rbuic\\rbuic4.exe bin\\#{ruby_version}"
    file.puts ""
    file.puts "installqt: makedirs"
    file.puts "\tcopy #{qt_sdk_path}\\bin\\*.dll qtbin"
    file.puts "\tdel /F /Q qtbin\\*d4.dll"
    file.puts "\tcopy #{qt_sdk_path}\\plugins\\accessible\\*.dll qtbin\\plugins\\accessible"
    file.puts "\tcopy #{qt_sdk_path}\\plugins\\bearer\\*.dll qtbin\\plugins\\bearer"
    file.puts "\tcopy #{qt_sdk_path}\\plugins\\codecs\\*.dll qtbin\\plugins\\codecs"
    file.puts "\tcopy #{qt_sdk_path}\\plugins\\designer\\*.dll qtbin\\plugins\\designer"
    file.puts "\tcopy #{qt_sdk_path}\\plugins\\graphicssystems\\*.dll qtbin\\plugins\\graphicssystems"
    file.puts "\tcopy #{qt_sdk_path}\\plugins\\iconengines\\*.dll qtbin\\plugins\\iconengines"
    file.puts "\tcopy #{qt_sdk_path}\\plugins\\imageformats\\*.dll qtbin\\plugins\\imageformats"
    file.puts "\tcopy #{qt_sdk_path}\\plugins\\phonon_backend\\*.dll qtbin\\plugins\\phonon_backend"
    file.puts "\tcopy #{qt_sdk_path}\\plugins\\qmltooling\\*.dll qtbin\\plugins\\qmltooling"
    file.puts "\tcopy #{qt_sdk_path}\\plugins\\sqldrivers\\*.dll qtbin\\plugins\\sqldrivers"
    file.puts "\tdel /F /Q qtbin\\plugins\\accessible\\*d.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\accessible\\*d4.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\bearer\\*d.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\bearer\\*d4.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\codecs\\*d.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\codecs\\*d4.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\designer\\*d.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\designer\\*d4.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\graphicssystems\\*d.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\graphicssystems\\*d4.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\iconengines\\*d.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\iconengines\\*d4.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\imageformats\\*d.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\imageformats\\*d4.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\phonon_backend\\*d.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\phonon_backend\\*d4.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\qmltooling\\*d.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\qmltooling\\*d4.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\sqldrivers\\*d.dll"
    file.puts "\tdel /F /Q qtbin\\plugins\\sqldrivers\\*d4.dll"
  else
    file.puts "all: clean build"
    file.puts ""
    file.puts "makedirs:"
    file.puts "\t-mkdir ext/build"
    file.puts "\t-mkdir bin/1.9"
    file.puts "\t-mkdir bin/2.0"
    file.puts "\t-mkdir bin/plugins"
    file.puts "\t-mkdir bin/plugins/accessible"
    file.puts "\t-mkdir bin/plugins/bearer"
    file.puts "\t-mkdir bin/plugins/codecs"
    file.puts "\t-mkdir bin/plugins/designer"
    file.puts "\t-mkdir bin/plugins/graphicssystems"
    file.puts "\t-mkdir bin/plugins/iconengines"
    file.puts "\t-mkdir bin/plugins/imageformats"
    file.puts "\t-mkdir bin/plugins/phonon_backend"
    file.puts "\t-mkdir bin/plugins/qmltooling"
    file.puts "\t-mkdir bin/plugins/sqldrivers"
    file.puts "\t-mkdir lib/1.9"
    file.puts "\t-mkdir lib/2.0"
    file.puts ""
    file.puts "clean: makedirs"
    file.puts "\t-cd ext/build; rm -rf CMakeFiles"
    file.puts "\t-cd ext/build; rm -rf generator"
    file.puts "\t-cd ext/build; rm -rf smoke"
    file.puts "\t-cd ext/build; rm -rf ruby"
    file.puts "\t-cd ext/build; rm *"
    file.puts ""
    file.puts "distclean: clean"
    file.puts "\t-cd bin && rm *.dll"
    file.puts "\t-cd bin && rm *.so"
    file.puts "\t-cd bin && rm *.exe"
    file.puts "\t-cd bin/plugins && rm *"
    file.puts "\t-cd bin/plugins/accessible && rm *"
    file.puts "\t-cd bin/plugins/bearer && rm *"
    file.puts "\t-cd bin/plugins/codecs && rm *"
    file.puts "\t-cd bin/plugins/designer && rm *"
    file.puts "\t-cd bin/plugins/graphicssystems && rm *"
    file.puts "\t-cd bin/plugins/iconengines && rm *"
    file.puts "\t-cd bin/plugins/imageformats && rm *"
    file.puts "\t-cd bin/plugins/phonon_backend && rm *"
    file.puts "\t-cd bin/plugins/qmltooling && rm *"
    file.puts "\t-cd bin/plugins/sqldrivers && rm *"
    file.puts "\t-cd bin/1.9 && rm *"
    file.puts "\t-cd bin/2.0 && rm *"
    file.puts "\t-cd lib/1.9 && rm *"
    file.puts "\t-cd lib/2.0 && rm *"
    file.puts "\t-rm Makefile"
    file.puts "\t-rm qtbindings-*.gem"
    file.puts ""
    file.puts "build: makedirs"
    file.puts "\t-cd ext/build; \\"
    file.puts "cmake \\"
    file.puts "-G \"Unix Makefiles\" \\"
    if ARGV[0] == '-d'
      file.puts "-DCMAKE_BUILD_TYPE=Debug \\"
    end
    file.puts "-Wno-dev \\"
    file.puts "-DENABLE_SMOKE=on \\"
    file.puts "-DENABLE_QTCORE_SMOKE=on \\"
    file.puts "-DENABLE_QTNETWORK_SMOKE=on \\"
    file.puts "-DENABLE_QTDBUS_SMOKE=on \\"
    file.puts "-DENABLE_QTGUI_SMOKE=on \\"
    file.puts "-DENABLE_QTSVG_SMOKE=on \\"
    file.puts "-DENABLE_QTSQL_SMOKE=on \\"
    file.puts "-DENABLE_QTXML_SMOKE=on \\"
    file.puts "-DENABLE_QTXMLPATTERNS_SMOKE=on \\"
    file.puts "-DENABLE_QTOPENGL_SMOKE=on \\"
    file.puts "-DENABLE_QTWEBKIT_SMOKE=on \\"
    file.puts "-DENABLE_QTSCRIPT_SMOKE=on \\"
    file.puts "-DENABLE_QTUITOOLS_SMOKE=on \\"
    file.puts "-DENABLE_QTTEST_SMOKE=on \\"
    file.puts "-DENABLE_QTMULTIMEDIA_SMOKE=on \\"
    file.puts "-DENABLE_QTRUBY=on \\"
    file.puts "-DENABLE_QTWEBKIT_RUBY=on \\"
    file.puts "-DENABLE_QTUITOOLS_RUBY=on \\"
    file.puts "-DENABLE_QTSCRIPT=on \\"
    file.puts "-DENABLE_QTTEST=on \\"
    file.puts "-DRUBY_EXECUTABLE=#{File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['RUBY_INSTALL_NAME'])} \\"
    file.puts ".."
    file.puts "\tcd ext/build; make"
    file.puts ""
    file.puts "install: makedirs"
    if macosx
      file.puts "\t-cp ext/build/smoke/smokeapi/smokeapi bin/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/deptool/smokedeptool bin/#{ruby_version}"
      file.puts "\t-cp ext/build/ruby/qtruby/src/qtruby4.so lib/#{ruby_version}/qtruby4.bundle"
      file.puts "\t-cp ext/build/ruby/qtscript/qtscript.* lib/#{ruby_version}/qtscript.bundle"
      file.puts "\t-cp ext/build/ruby/qttest/qttest.* lib/#{ruby_version}/qttest.bundle"
      file.puts "\t-cp ext/build/ruby/qtuitools/qtuitools.* lib/#{ruby_version}/qtuitools.bundle"
      file.puts "\t-cp ext/build/ruby/qtwebkit/qtwebkit.* lib/#{ruby_version}/qtwebkit.bundle"
      file.puts "\t-cp ext/build/ruby/qtruby/tools/rbrcc/rbrcc bin/#{ruby_version}"
      file.puts "\t-cp ext/build/ruby/qtruby/tools/rbuic/rbuic4 bin/#{ruby_version}"
    else
      file.puts "\t-cp ext/build/smoke/deptool/smokedeptool bin/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtcore/libsmokeqtcore.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtdbus/libsmokeqtdbus.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtgui/libsmokeqtgui.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qthelp/libsmokeqthelp.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtmultimedia/libsmokeqtmultimedia.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtnetwork/libsmokeqtnetwork.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtopengl/libsmokeqtopengl.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtscript/libsmokeqtscript.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtsql/libsmokeqtsql.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtsvg/libsmokeqtsvg.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qttest/libsmokeqttest.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtuitools/libsmokeqtuitools.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtwebkit/libsmokeqtwebkit.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtxml/libsmokeqtxml.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/qtxmlpatterns/libsmokeqtxmlpatterns.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/smokeapi/smokeapi bin/#{ruby_version}"
      file.puts "\t-cp ext/build/smoke/smokebase/libsmokebase.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/ruby/qtruby/src/libqtruby4shared.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/ruby/qtruby/src/qtruby4.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/ruby/qtscript/qtscript.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/ruby/qttest/qttest.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/ruby/qtuitools/qtuitools.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/ruby/qtwebkit/qtwebkit.* lib/#{ruby_version}"
      file.puts "\t-cp ext/build/ruby/qtruby/tools/rbrcc/rbrcc bin/#{ruby_version}"
      file.puts "\t-cp ext/build/ruby/qtruby/tools/rbuic/rbuic4 bin/#{ruby_version}"
    end
  end
end
