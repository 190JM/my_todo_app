import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_todo_app/model/todo_item.dart';
import 'package:my_todo_app/utils/data_utils.dart';

class WorkCard extends StatefulWidget {
  TodoItem todoItem;
  Function(TodoItem item)? onEditTodoItem;
  Function(TodoItem item, BuildContext context)? toggleTodoItem;
  Function(TodoItem item, BuildContext context)? onDeleteItem;
  WorkCard({
    super.key,
    required this.todoItem,
    this.onEditTodoItem,
    this.toggleTodoItem,
    this.onDeleteItem,
  });

  @override
  State<WorkCard> createState() => _WorkCardState();
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

class _WorkCardState extends State<WorkCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color(0xffDBDBDB)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: ()  {
              if (widget.toggleTodoItem != null) {
                widget.toggleTodoItem!(widget.todoItem, context);
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 10, top: 25),
              width: 22,
              height: 22 ,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color:  Colors.white,
                border: Border.all(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              child: widget.todoItem.isDone
                  ? Padding(
                padding: const EdgeInsets.all(3.0),
                child: SvgPicture.asset('assets/svg/icon_check.svg'),
              )
                  : Container(),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (widget.onEditTodoItem != null) {
                  widget.onEditTodoItem!(widget.todoItem);
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      TodoDataUtils.dateFormat(widget.todoItem.createdAt),
                      style: GoogleFonts.notoSans(
                        fontSize: 11,
                        color: Colors.grey.withOpacity(0.8),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 65,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            widget.todoItem.todo,
                            style: GoogleFonts.notoSans(
                              decoration: widget.todoItem.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            widget.todoItem.description,
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: const Color(0xff777777),
                              decoration: widget.todoItem.isDone
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
          widget.onDeleteItem == null
              ? Container()
              : GestureDetector(
            onTap: () {
              if (widget.onDeleteItem != null) {
                widget.onDeleteItem!(widget.todoItem,context);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20.0, left: 15, right: 15, bottom: 15),
              child: SvgPicture.asset('assets/svg/icon_delete.svg'),
            ),
          )
        ],
      ),
    );
  }
}