class ApiErrorResponse implements Exception {
  final bool status;
  final String message;

  ApiErrorResponse({required this.status, required this.message});

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      status: json['status'] == true,
      message: json['message']?.toString() ?? 'Unknown error',
    );
  }

  @override
  String toString() => message;
}
