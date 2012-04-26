PROJECT_HOME=./jlbiosutils
echo $PROJECT_HOME

LIBOUTPUTDIR=../lib/jlbiosutils

SRCPATH=./jlbiosutils

BUILDDIR=$PROJECT_HOME/build
echo $BUILDDIR
# The Xcode bin path
if [ -d "/Developer/usr/bin" ]; then
   # < XCode 4.3.1
  XCODEBUILD_PATH=/Developer/usr/bin
else
  # >= XCode 4.3.1, or from App store
  XCODEBUILD_PATH=/Applications/XCode.app/Contents/Developer/usr/bin
fi
XCODEBUILD=$XCODEBUILD_PATH/xcodebuild
test -x "$XCODEBUILD" || die "Could not find xcodebuild in $XCODEBUILD_PATH"

cd $PROJECT_HOME
$XCODEBUILD -target "jlbiosutils" -sdk "iphonesimulator" -configuration "Release" SYMROOT=$BUILDDIR clean build || die "iOS Simulator build failed"
$XCODEBUILD -target "jlbiosutils" -sdk "iphoneos" -configuration "Release" SYMROOT=$BUILDDIR clean build || die "iOS Device build failed"


echo "Step 2 : Remove older SDK Directory"

\rm -rf $LIBOUTPUTDIR

echo "Step 3 : Create new SDK Directory Version"

mkdir -p $LIBOUTPUTDIR

echo "Step 4 : Create combine lib files for various platforms into one"

# combine lib files for various platforms into one
lipo -create $BUILDDIR/Release-iphonesimulator/libjlbiosutils.a $BUILDDIR/Release-iphoneos/libjlbiosutils.a -output $LIBOUTPUTDIR/libjlbiosutils.a || die "Could not create static output library"

#copy header files to lib output
cp $SRCPATH/*.h $LIBOUTPUTDIR/

echo "Finished Universal jlbiosutils SDK Generation"
echo ""
echo "You can now use the static library that can be found at:"
echo ""
echo "/lib"
echo ""
echo "Just drag the jlbiosutils directory into your project to include the jlbiosutils iOS SDK static library"
echo ""
echo ""
