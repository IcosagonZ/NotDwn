import 'dart:io';

bool windowIsFullscreen = false;

void toggle_fullscreen(){
  if(windowIsFullscreen){
    if(Platform.isAndroid){
      // hide status bar
    }
    else{
      // do desktop fullscreen
    }
    windowIsFullscreen = false;
  }
  else{
    if(Platform.isAndroid){
      // show status bar
    }
    else{
      // do desktop unfullscreen
    }
    windowIsFullscreen = true;
  }
}
