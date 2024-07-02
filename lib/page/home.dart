import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/components/todo_calendar.dart';
import 'package:my_todo_app/components/work_card.dart';
import 'package:my_todo_app/components/work_editor.dart';
import 'package:my_todo_app/controller/home_controller.dart';
import 'package:my_todo_app/controller/work_editor_controller.dart';
import 'package:my_todo_app/utils/data_utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TodoHome extends GetView<HomeController> {
  const TodoHome({super.key});

  Widget _header() {
    return Padding(
      key: controller.calendarHeaderKey,
      padding: const EdgeInsets.only(top: 5, bottom: 15),
      child: Obx(
            () => Text(
          TodoDataUtils.mainHeaderDateToString(controller.headerDate.value),
          style: GoogleFonts.notoSans(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _calendalWidget() {
    return SizedBox(
      key: controller.calendarKey,
      height: 330,
      child: Obx(
            () => TodoCalendar(
          focusMonth: controller.headerDate.value,
          todoItmes: controller.currentMonthTodoList.value,
          onCalendarCreated: controller.onCalendarCreated,
          onPageChange: controller.onPageChange,
          onSelectedDate: controller.onSelectedDate,
        ),
      ),
    );
  }

  Widget _scrollingList(ScrollController sc) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Colors.grey.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 25),
        _tabMenu(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TabBarView(
              controller: controller.tabController,
              children: [
                _todoListWidget(),
                _workedDoneListWidget(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _tabMenu() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      width: Size.infinite.width,
      child: TabBar(
        controller: controller.tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Colors.cyan,
        labelStyle: GoogleFonts.notoSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        tabs: const [
          Tab(text: '할일'),
          Tab(text: '완료'),
        ],
      ),
    );
  }

  Widget _todoListWidget() {
    return Obx(
          () => controller.currentTodoListByCurrentDate.isEmpty
          ? _emptyMessageWidget('할 일이 없습니다.')
          : ListView.builder(
        itemCount: controller.currentTodoListByCurrentDate.length,
        itemBuilder: (context, index) {
          return WorkCard(
            todoItem: controller.currentTodoListByCurrentDate[index],
            onEditTodoItem: controller.editTodoItem,
            toggleTodoItem: (item, context) {
              controller.toggleTodoItem(item);
              showCustomSnackBar(context, '할 일 완료', '완료 리스트에 추가됐어요!');
            },
            onDeleteItem:(item, context){
              controller.deleteTodoItem(item);
              showCustomSnackBar(context, '할 일 삭제', '할 일이 리스트에서 삭제됐어요!');
            },
          );
        },
      ),
    );
  }

  Widget _emptyMessageWidget(String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 100),
      child: SizedBox(
        height: 150,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SvgPicture.asset('assets/svg/icon_no_data.svg'),
          const SizedBox(height: 15),
          Text(
            message,
            style: GoogleFonts.notoSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )
        ]),
      ),
    );
  }

  Widget _workedDoneListWidget() {
    return Obx(
          () => controller.currentWorkDoneListByCurrentDate.isEmpty
          ? _emptyMessageWidget('완료된 작업이 없습니다.')
          : ListView.builder(
        itemCount: controller.currentWorkDoneListByCurrentDate.length,
        itemBuilder: (context, index) {
          return WorkCard(
            todoItem: controller.currentWorkDoneListByCurrentDate[index],
            onEditTodoItem: controller.editTodoItem,
            toggleTodoItem: (item, context) {
              controller.toggleTodoItem(item);
              showCustomSnackBar(context, '한 일 취소', '할 일 리스트에 추가됐어요!');
            },
            onDeleteItem:(item, context){
              controller.deleteTodoItem(item);
              showCustomSnackBar(context, '한 일 삭제', '한 일이 리스트에서 삭제됐어요!');
            },
          );
        },
      ),
    );
  }


  Widget _bottomProgressBarWidget() {
    return Container(
      height: 8 + Get.mediaQuery.padding.bottom,
      color: const Color.fromARGB(255, 237, 237, 237),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Obx(
              () => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: Get.width * controller.progress.value,
            height: 8 + Get.mediaQuery.padding.bottom,
            color:  Colors.cyan,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Obx(
              () => SlidingUpPanel(
            minHeight: controller.slidingUpPanelMinHeight,
            maxHeight: controller.slidingUpPanelMaxHeight,
            panelBuilder: (ScrollController sc) => _scrollingList(sc),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            body: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  children: [
                    _header(),
                    const SizedBox(height: 10),
                    _calendalWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan,
        shape: const CircleBorder(),
        onPressed: () async {
          var results = await Get.to(
                () => const WorkEditor(),
            opaque: false,
            fullscreenDialog: true,
            duration: Duration.zero,
            transition: Transition.downToUp,
            binding: BindingsBuilder(
                  () {
                Get.put(WorkEditorController());
              },
            ),
          );
        },
        child: Center(
          child: SvgPicture.asset('assets/svg/icon_edit.svg'),
        ),
      ),
      bottomNavigationBar: _bottomProgressBarWidget(),
    );
  }
}