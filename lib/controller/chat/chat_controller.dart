import 'package:get/get.dart';

class ChatController extends GetxController {
  // Define your variables and methods here

  // Example variable
  var messages = <String>[].obs;

  // Example method to add a message
  void addMessage(String message) {
    messages.add(message);
  }

  // Example method to clear messages
  void clearMessages() {
    messages.clear();
  }
}
