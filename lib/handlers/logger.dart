bool loggerEnabled = true;

List<String> loggerIgnore = ["Settings", "Recents"];

void log(String caller, String message){
  if(loggerEnabled){
    if(!loggerIgnore.contains(caller))
    {
      print("[$caller] $message");
    }
  }
}
