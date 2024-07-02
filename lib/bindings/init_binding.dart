import 'package:get/get.dart';
import 'package:my_todo_app/controller/database_controller.dart';

class InitBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(DataBaseController());
  }
}