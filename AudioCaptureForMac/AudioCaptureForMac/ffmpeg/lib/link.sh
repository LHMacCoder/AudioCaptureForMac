install_name_tool -id @rpath/libavcodec.59.1.101.dylib libavcodec.59.1.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libswresample.4.dylib @rpath/libswresample.4.0.100.dylib libavcodec.59.1.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavutil.57.dylib @rpath/libavutil.57.0.100.dylib libavcodec.59.1.101.dylib;

install_name_tool -id @rpath/libavdevice.59.0.100.dylib libavdevice.59.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavfilter.8.dylib @rpath/libavfilter.8.0.101.dylib libavdevice.59.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libswscale.6.dylib @rpath/libswscale.6.0.100.dylib libavdevice.59.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libpostproc.56.dylib @rpath/libpostproc.56.0.100.dylib libavdevice.59.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavformat.59.dylib @rpath/libavformat.59.2.101.dylib libavdevice.59.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavcodec.59.dylib @rpath/libavcodec.59.1.101.dylib libavdevice.59.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libswresample.4.dylib @rpath/libswresample.4.0.100.dylib libavdevice.59.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavutil.57.dylib @rpath/libavutil.57.0.100.dylib libavdevice.59.0.100.dylib;

install_name_tool -id @rpath/libavfilter.8.0.101.dylib libavfilter.8.0.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libswscale.6.dylib @rpath/libswscale.6.0.100.dylib libavfilter.8.0.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libpostproc.56.dylib @rpath/libpostproc.56.0.100.dylib libavfilter.8.0.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavformat.59.dylib @rpath/libavformat.59.2.101.dylib libavfilter.8.0.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavcodec.59.dylib @rpath/libavcodec.59.1.101.dylib libavfilter.8.0.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libswresample.4.dylib @rpath/libswresample.4.0.100.dylib libavfilter.8.0.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavutil.57.dylib @rpath/libavutil.57.0.100.dylib libavfilter.8.0.101.dylib;

install_name_tool -id @rpath/libavformat.59.2.101.dylib libavformat.59.2.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavformat.59.dylib @rpath/libavformat.59.2.101.dylib libavformat.59.2.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavcodec.59.dylib @rpath/libavcodec.59.1.101.dylib libavformat.59.2.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libswresample.4.dylib @rpath/libswresample.4.0.100.dylib libavformat.59.2.101.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavutil.57.dylib @rpath/libavutil.57.0.100.dylib libavformat.59.2.101.dylib;

install_name_tool -id @rpath/libavutil.57.0.100.dylib libavutil.57.0.100.dylib;

install_name_tool -id @rpath/libpostproc.56.0.100.dylib libpostproc.56.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libpostproc.56.dylib @rpath/libpostproc.56.0.100.dylib libpostproc.56.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavutil.57.dylib @rpath/libavutil.57.0.100.dylib libpostproc.56.0.100.dylib;

install_name_tool -id @rpath/libswresample.4.0.100.dylib libswresample.4.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libswresample.4.dylib @rpath/libswresample.4.0.100.dylib libswresample.4.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavutil.57.dylib @rpath/libavutil.57.0.100.dylib libswresample.4.0.100.dylib;

install_name_tool -id @rpath/libswscale.6.0.100.dylib libswscale.6.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libswscale.6.dylib @rpath/libswscale.6.0.100.dylib libswscale.6.0.100.dylib;
install_name_tool -change /usr/local/ffmpeg/lib/libavutil.57.dylib @rpath/libavutil.57.0.100.dylib libswscale.6.0.100.dylib;

