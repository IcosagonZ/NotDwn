bool loggerEnabled = true;

List<String> loggerIgnore = ["Settings"];

void log(String caller, String message){
  if(loggerEnabled){
    if(!loggerIgnore.contains(caller))
    {
      print("[$caller] $message");
    }
  }
}
