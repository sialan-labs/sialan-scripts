# Your package directory should be like this:
# AppName.app
#       |____ Contents
#                 |_____ Frameworks
#                 |        |_____ QtCore.framework
#                 |        |_____ QtGui.framework
#                 |        |_____ QtQuick.framework
#                 |        |_____ Other Qt framework libs
#                 |        
#                 |_____ MacOS
#                 |        |_____ AppName
#                 |        
#                 |_____ plugins
#                 |        |_____ audio
#                 |        |_____ iconengines
#                 |        |_____ imageformats
#                 |        |_____ other Qt plugins
#                 |        
#                 |_____ qml
#                 |        |_____ QtGraphicalEffects
#                 |        |_____ QtQuick.2
#                 |        |_____ other Qt framework qml plugins
#                 |        
#                 |_____ Resources
#                          |_____ Your application resource files
#

APP_NAME="AppName"
QT_INSTALL_DIR="/Users/bardia/Qt5.3.1/5.3/clang_64"
COMPONENTS="Enginio QtBluetooth QtCLucene QtConcurrent QtCore QtDBus QtDeclarative QtDesignerComponents QtDesigner QtGui QtHelp QtMacExtras QtMultimediaQuick_p QtMultimediaWidgets QtMultimedia QtNetwork QtNfc QtOpenGL QtPositioning QtPrintSupport QtQml QtQuickParticles QtQuickTest QtQuickWidgets QtQuick QtScriptTools QtScript QtSensors QtSerialPort QtSql QtSvg QtTest QtWebKitWidgets QtWebKit QtWebSockets QtWidgets QtXmlPatterns QtXml libQt5OpenGLExtensions libQt5PlatformSupport libQt5UiTools"

cd "$APP_NAME"
rm `find . -name "*_debug.dylib"`
rm `find . -name "*_debug"`
rm -rf`find . -name "Headers"`
cd ..

for CMPNT in $COMPONENTS
do
    install_name_tool -change "$QT_INSTALL_DIR"/lib/"$CMPNT".framework/Versions/5/"$CMPNT" @executable_path/../Frameworks/"$CMPNT".framework/Versions/5/"$CMPNT" "$APP_NAME".app/Contents/MacOS/"$APP_NAME" 
    install_name_tool -id @executable_path/../Frameworks/"$CMPNT".framework/Versions/5/"$CMPNT" "$APP_NAME".app/Contents/Frameworks/"$CMPNT".framework/Versions/5/"$CMPNT"
    
    for LIBCMPNT in $COMPONENTS
    do
        install_name_tool -change "$QT_INSTALL_DIR"/lib/"$LIBCMPNT".framework/Versions/5/"$LIBCMPNT" @executable_path/../Frameworks/"$LIBCMPNT".framework/Versions/5/"$LIBCMPNT" "$APP_NAME".app/Contents/Frameworks/"$CMPNT".framework/Versions/5/"$CMPNT"
    done
done

DYLIBS=`find ./"$APP_NAME".app/ -name "*.dylib" -type f`
for DLIB in $DYLIBS
do
    for CMPNT in $COMPONENTS
    do
        install_name_tool -change "$QT_INSTALL_DIR"/lib/"$CMPNT".framework/Versions/5/"$CMPNT" @executable_path/../Frameworks/"$CMPNT".framework/Versions/5/"$CMPNT" "$DLIB"
    done
done

echo " " > "$APP_NAME".app/Contents/Resources/qt.conf
