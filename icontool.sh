#!/bin/bash

if [ $# -ne 1 ]; then
  echo 'using res_compress [folder-name] to upload res'
  exit -1
fi

cwd=$(pwd)

src=$1
if [ ! -f $src ]; then
  src=$cwd/$1
fi

des=$src"-icon"

echo "using src: "$src
echo "will save to: "$des

rm -rf $des
mkdir -p $des

ios=$des"/Images.xcassets/AppIcon.appiconset"
mkdir -p $ios

echo '{"images":[{"idiom":"iphone","size":"20x20","filename":"Icon-40.png","scale":"2x"},{"idiom":"iphone","size":"20x20","filename":"Icon-60.png","scale":"3x"},{"size":"29x29","idiom":"iphone","filename":"Icon-58.png","scale":"2x"},{"size":"29x29","idiom":"iphone","filename":"Icon-87.png","scale":"3x"},{"size":"40x40","idiom":"iphone","filename":"Icon-80.png","scale":"2x"},{"size":"40x40","idiom":"iphone","filename":"Icon-120.png","scale":"3x"},{"size":"60x60","idiom":"iphone","filename":"Icon-120.png","scale":"2x"},{"size":"60x60","idiom":"iphone","filename":"Icon-180.png","scale":"3x"},{"idiom":"ipad","size":"20x20","filename":"Icon-20.png","scale":"1x"},{"idiom":"ipad","size":"20x20","filename":"Icon-40.png","scale":"2x"},{"size":"29x29","idiom":"ipad","filename":"Icon-29.png","scale":"1x"},{"size":"29x29","idiom":"ipad","filename":"Icon-58.png","scale":"2x"},{"size":"40x40","idiom":"ipad","filename":"Icon-40.png","scale":"1x"},{"size":"40x40","idiom":"ipad","filename":"Icon-80.png","scale":"2x"},{"size":"76x76","idiom":"ipad","filename":"Icon-76.png","scale":"1x"},{"size":"76x76","idiom":"ipad","filename":"Icon-152.png","scale":"2x"},{"size":"83.5x83.5","idiom":"ipad","filename":"Icon-167.png","scale":"2x"},{"size":"1024x1024","idiom":"ios-marketing","filename":"Icon-1024.png","scale":"1x"}],"info":{"version":1,"author":"xcode"}}' >$ios"/Contents.json"

magick $src -resize 20x20 $ios"/Icon-20.png"
magick $src -resize 29x29 $ios"/Icon-29.png"
magick $src -resize 40x40 $ios"/Icon-40.png"
magick $src -resize 60x60 $ios"/Icon-60.png"
magick $src -resize 58x58 $ios"/Icon-58.png"
magick $src -resize 76x76 $ios"/Icon-76.png"
magick $src -resize 80x80 $ios"/Icon-80.png"
magick $src -resize 87x87 $ios"/Icon-87.png"
magick $src -resize 120x120 $ios"/Icon-120.png"
magick $src -resize 152x152 $ios"/Icon-152.png"
magick $src -resize 167x167 $ios"/Icon-167.png"
magick $src -resize 180x180 $ios"/Icon-180.png"
magick $src -resize 1024x1024 $ios"/Icon-1024.png"

mkdir -p $des"/mipmap-mdpi"
magick $src -resize 48x48 $des"/mipmap-mdpi/ic_launcher.png"

mkdir -p $des"/mipmap-hdpi"
magick $src -resize 72x72 $des"/mipmap-hdpi/ic_launcher.png"

mkdir -p $des"/mipmap-xhdpi"
magick $src -resize 96x96 $des"/mipmap-xhdpi/ic_launcher.png"

mkdir -p $des"/mipmap-xxhdpi"
magick $src -resize 144x144 $des"/mipmap-xxhdpi/ic_launcher.png"

mkdir -p $des"/mipmap-xxxhdpi"
magick $src -resize 512x512 $des"/mipmap-xxxhdpi/ic_launcher.png"

mkdir -p $des"/ico"
magick $src -resize 72x72 $des"/ico/icon.ico"