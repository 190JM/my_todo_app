import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/controller/work_editor_controller.dart';
import 'package:my_todo_app/utils/data_utils.dart';

class WorkEditor extends GetView<WorkEditorController> {
  const WorkEditor({
    super.key,
  });

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            TodoDataUtils.dateFormat(controller.createdAt,
                format: 'yyyy.MM.dd'),
            style: GoogleFonts.notoSans(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: controller.back,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '취소',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _title() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: const Color(0xffeeeeee),
      ),
      child: TextField(
        controller: controller.titleController,
        decoration: const InputDecoration(
          hintText: '할일을 입력해주세요.',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _desciption() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: const Color(0xffeeeeee),
      ),
      child: TextField(
        maxLines: null,
        expands: true,
        controller: controller.dscriptionController,
        decoration: const InputDecoration(
          hintText: '할일에 대해 설명을 입력해주세요.',
          border: InputBorder.none,
        ),
      ),
    );
  }

  Future<void> showCustomSnackBar(
      BuildContext context, String title, String message) async {
    Flushbar(
      margin: const EdgeInsets.all(8),
      flushbarPosition: FlushbarPosition.TOP,
      borderRadius: BorderRadius.circular(8),
      barBlur: 5,
      backgroundColor: Colors.grey.withOpacity(0.3),
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.check,
        color: Colors.blue,
      ),
      titleText: Text(
        title,
        style: const TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
      ),
      messageText: Text(
        message,
        style: const TextStyle(color: Colors.black, fontSize: 13),
      ),
    ).show(context);
  }

  Widget _btn(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await controller.submit();
        if (controller.isEditMode) {
          showCustomSnackBar(context, '수정 완료', 'Todo 리스트가 수정됐어요');
        } else {
          showCustomSnackBar(context, '작성 완료', 'Todo 리스트가 추가됐어요');
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Colors.cyan,
        ),
        child: Text(
          controller.isEditMode ? '수정' : '등록',
          style: GoogleFonts.notoSans(
            fontSize: 17,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: controller.focusOut,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.7),
            ),
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                top: controller.modalPosition.value,
                bottom: 0,
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(),
                      _title(),
                      const SizedBox(height: 15),
                      Expanded(child: _desciption()),
                      _btn(context),
                      SizedBox(height: Get.mediaQuery.padding.bottom),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
