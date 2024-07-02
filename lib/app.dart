import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/controller/database_controller.dart';
import 'package:my_todo_app/controller/home_controller.dart';
import 'package:my_todo_app/page/home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Container(
        color: Colors.white,
        child: FutureBuilder<bool>(
            future: DataBaseController.to.initDataBase(),
            builder: (_, snaphot) {
              if (snaphot.hasError) {
                return const Center(
                  child: Text('sqflite를 지원하지 않습니다.'),
                );
              }
              if (snaphot.hasData) {
                Get.put(HomeController());
                return const TodoHome();
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}