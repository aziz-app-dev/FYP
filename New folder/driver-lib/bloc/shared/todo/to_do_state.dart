import 'package:equatable/equatable.dart';

class ToDoState extends Equatable {
  final List<String> todo;
  const ToDoState({this.todo = const []});

  ToDoState copyWith({List<String>? todo}) {
    return ToDoState(todo: todo ?? this.todo);
  }

  @override
  List<Object> get props => [todo];
}
