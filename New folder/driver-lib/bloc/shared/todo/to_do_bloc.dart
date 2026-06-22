import 'package:bloc/bloc.dart';

import 'to_do_event.dart';
import 'to_do_state.dart';

class ToDoBloc extends Bloc<ToDoEvent, ToDoState> {
  ToDoBloc() : super(ToDoState()) {
    on<AddTaskEvent>(_addTask);
    on<RemoveTaskEvent>(_removeTask);
  }
  void _addTask(AddTaskEvent event, Emitter<ToDoState> emit) {
    final List<String> todoList = List<String>.from(state.todo);
    todoList.add(event.task);
    emit(state.copyWith(todo: todoList));
  }

  void _removeTask(RemoveTaskEvent event, Emitter<ToDoState> emit) {
    final List<String> todoList = List<String>.from(state.todo);
    todoList.remove(event.task);
    emit(state.copyWith(todo: todoList));
  }
}
