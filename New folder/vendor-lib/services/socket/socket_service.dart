import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../const/app_url.dart';
import '../session/session_manger.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? _socket;
  final _statusUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _restaurantRequestController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _restaurantOrderUpdateController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _globalNotificationController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _restaurantStatusController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _adminRestaurantRequestController =
      StreamController<Map<String, dynamic>>.broadcast();
  final _driverOrderAvailableController =
      StreamController<Map<String, dynamic>>.broadcast();

  Stream<Map<String, dynamic>> get statusUpdates =>
      _statusUpdateController.stream;
  Stream<Map<String, dynamic>> get restaurantOrderRequests =>
      _restaurantRequestController.stream;
  Stream<Map<String, dynamic>> get restaurantOrderUpdates =>
      _restaurantOrderUpdateController.stream;
  Stream<Map<String, dynamic>> get globalNotifications =>
      _globalNotificationController.stream;
  Stream<Map<String, dynamic>> get restaurantStatusUpdates =>
      _restaurantStatusController.stream;
  Stream<Map<String, dynamic>> get adminRestaurantRequests =>
      _adminRestaurantRequestController.stream;
  Stream<Map<String, dynamic>> get driverOrderAvailable =>
      _driverOrderAvailableController.stream;

  bool get isConnected => _socket?.connected ?? false;

  Map<String, dynamic> _asMap(dynamic data) {
    if (data is Map<String, dynamic>) return data;
    if (data is Map) {
      return data.map((key, value) => MapEntry(key.toString(), value));
    }
    return {'payload': data};
  }

  void init(String token, {String? userId}) {
    if (_socket != null) {
      _socket!.disconnect();
      _socket = null;
    }

    final resolvedUserId = userId ?? SessionManager().user?.id;

    _socket = io.io(AppUrl.baseUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'auth': {'token': token, 'userId': resolvedUserId},
      'query': {'userId': resolvedUserId},
    });

    _socket!.onConnect((_) {
      debugPrint('Socket connected to ${AppUrl.baseUrl}');
    });

    _socket!.on('orderStatusUpdate', (data) {
      debugPrint('Received orderStatusUpdate: $data');
      _statusUpdateController.add(data);
    });

    _socket!.on('restaurantOrderRequest', (data) {
      debugPrint('Received restaurantOrderRequest: $data');
      _restaurantRequestController.add(_asMap(data));
    });

    _socket!.on('restaurantOrderUpdate', (data) {
      debugPrint('Received restaurantOrderUpdate: $data');
      _restaurantOrderUpdateController.add(_asMap(data));
    });

    _socket!.on('globalNotification', (data) {
      debugPrint('Received globalNotification: $data');
      _globalNotificationController.add(_asMap(data));
    });

    _socket!.on('restaurantStatusUpdate', (data) {
      debugPrint('Received restaurantStatusUpdate: $data');
      _restaurantStatusController.add(_asMap(data));
    });

    _socket!.on('restaurantRequest', (data) {
      debugPrint('Received restaurantRequest: $data');
      _adminRestaurantRequestController.add(_asMap(data));
    });

    _socket!.on('driverOrderAvailable', (data) {
      debugPrint('Received driverOrderAvailable: $data');
      _driverOrderAvailableController.add(_asMap(data));
    });

    _socket!.onDisconnect((_) {
      debugPrint('Socket disconnected');
    });

    _socket!.onConnectError((err) {
      debugPrint('Socket connect error: $err');
    });
  }

  void joinRestaurantRoom(String restaurantId) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('joinRestaurant', {'restaurantId': restaurantId});
    debugPrint('Joined restaurant room: $restaurantId');
  }

  void leaveRestaurantRoom(String restaurantId) {
    if (_socket == null || !_socket!.connected) return;
    _socket!.emit('leaveRestaurant', {'restaurantId': restaurantId});
    debugPrint('Left restaurant room: $restaurantId');
  }

  void disconnect() {
    _socket?.disconnect();
    _socket = null;
  }

  void dispose() {
    disconnect();
    _statusUpdateController.close();
    _restaurantRequestController.close();
    _restaurantOrderUpdateController.close();
    _globalNotificationController.close();
    _restaurantStatusController.close();
    _adminRestaurantRequestController.close();
    _driverOrderAvailableController.close();
  }
}
