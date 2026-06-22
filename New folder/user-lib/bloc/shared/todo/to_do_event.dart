import 'package:equatable/equatable.dart';

abstract class ToDoEvent extends Equatable {
  const ToDoEvent();
  @override
  List<Object?> get props => [];
}

class AddTaskEvent extends ToDoEvent {
  final String task;

  const AddTaskEvent({required this.task});
  @override
  List<Object?> get props => [task];
}

class RemoveTaskEvent extends ToDoEvent {
  final Object task;

  const RemoveTaskEvent({required this.task});
  @override
  List<Object?> get props => [task];
}
