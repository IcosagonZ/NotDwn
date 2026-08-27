import 'package:material_ui/material_ui.dart';

class DialogSnackbar{
  // Snack bar
  void showSnackBar(BuildContext context, String message, int code){
    // -1 means hide snackbar
    if(code==-1){
      return;
    }

    final colorScheme = Theme.of(context).colorScheme;
    Color colorPrimary = colorScheme.primary;
    Color colorNormalContainer = colorScheme.inversePrimary;

    Color colorError = colorScheme.error;
    Color colorErrorContainer = colorScheme.errorContainer;

    Color colorForeground =colorPrimary;
    Color colorBackground = colorNormalContainer;

    if(code!=0){
      colorForeground = colorError;
      colorBackground = colorErrorContainer;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color:colorForeground
          )
        ),
        backgroundColor: colorBackground,
        closeIconColor: colorForeground,
        showCloseIcon: true,
      )
    );
  }
}
