abstract class PaginatedEvent {}

class FetchItems extends PaginatedEvent {
  final bool refresh;
  FetchItems({this.refresh = false});
}

class LoadMoreItems extends PaginatedEvent {}
