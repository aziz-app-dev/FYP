import '../../utils/enums.dart';

class ApiResponse<T> {
  // ← renamed to ApiResponse (more standard naming)
  final Status status;
  final T? data;
  final String? message; // renamed from msg → clearer

  ApiResponse({required this.status, this.data, this.message});

  // Factory constructors for common states

  factory ApiResponse.initial() {
    return ApiResponse(status: Status.initial);
  }

  factory ApiResponse.loading() {
    return ApiResponse(status: Status.loading);
  }

  factory ApiResponse.success(T? data, {String? message}) {
    return ApiResponse(status: Status.success, data: data, message: message);
  }

  factory ApiResponse.error(String? message) {
    return ApiResponse(
      status: Status.error,
      message: message ?? "An error occurred",
    );
  }

  // Convenience getters
  bool get isInitial => status == Status.initial;
  bool get isLoading => status == Status.loading;
  bool get isSuccess => status == Status.success;
  bool get isError => status == Status.error;

  @override
  String toString() {
    return 'ApiResponse(status: $status, data: $data, message: $message)';
  }
}
