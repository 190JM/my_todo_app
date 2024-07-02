import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_todo_app/controller/home_controller.dart';
import 'package:my_todo_app/model/todo_item.dart';
import 'package:my_todo_app/repository/todo_repository.dart';

class WorkEditorController extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController dscriptionController = TextEditingController();
  bool isEditMode = false;
  bool isLoaded = false;
  int editItemId = -1;
  RxDouble modalPosition = (Get.height - 300).obs;
  late DateTime createdAt;

  @override
  void onInit() {
    super.onInit();
    createdAt = HomeController.to.currentDate;
    if (Get.arguments != null && Get.arguments['editItem'] != null) {
      var editItem = (Get.arguments['editItem'] as TodoItem);
      editItemId = editItem.id!;
      isEditMode = true;
      titleController.text = editItem.todo;
      createdAt = editItem.createdAt;
      dscriptionController.text = editItem.description;
    }
    _setModalPosition();
    isLoaded = true;
  }

  void _setModalPosition() async {
    await Future.delayed(const Duration(milliseconds: 100));
    modalPosition(modalPositionValue);
  }

  double get modalPositionValue {
    return HomeController.to.calendarHeaderSize.value.height -
        Get.mediaQuery.padding.top +
        Get.mediaQuery.padding.bottom;
  }

  Future<void> submit() async {
    var title = titleController.text;
    var discription = dscriptionController.text;
    try {
      if (title.trim() != '') {
        var todoItem = TodoItem(
          todo: title,
          description: discription,
          createdAt: HomeController.to.currentDate,
        );

        var result = -1;
        if (isEditMode) {
          result = await TodoRepository.update(todoItem.clone(id: editItemId));
        } else {
          result = await TodoRepository.create(todoItem);
        }
        if (result > 0) {
          HomeController.to.refreshCurrentMonth();
          back();
        }
      }
    } catch (e) {
      //메세지 처리
    }
  }

  void focusOut() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  void back() {
    focusOut();
    Get.back();
  }
}