class ReservationModel {
  final String? id;
  final String? userId;
  final String? restaurantId;
  final ReservationRestaurant? restaurant;
  final DateTime? date;
  final String? timeSlot;
  final int? numberOfGuests;
  final String? tableId;
  final String? roomId;
  final String? areaPreference;
  final String? reservationType;
  final String? status;
  final String? specialRequests;
  final TableDetails? tableDetails;
  final RoomDetails? roomDetails;
  final DateTime? createdAt;

  ReservationModel({
    this.id,
    this.userId,
    this.restaurantId,
    this.restaurant,
    this.date,
    this.timeSlot,
    this.numberOfGuests,
    this.tableId,
    this.roomId,
    this.areaPreference,
    this.reservationType,
    this.status,
    this.specialRequests,
    this.tableDetails,
    this.roomDetails,
    this.createdAt,
  });

  bool get isPending => status == 'Pending';
  bool get isConfirmed => status == 'Confirmed';
  bool get isCancelled => status == 'Cancelled';
  bool get isCompleted => status == 'Completed';
  bool get canCancel => isPending || isConfirmed;
  bool get isUpcoming => canCancel && date != null && date!.isAfter(DateTime.now().subtract(const Duration(days: 1)));

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    // restaurantId can be a populated object or a string
    String? restId;
    ReservationRestaurant? restaurant;
    if (json['restaurantId'] is Map<String, dynamic>) {
      restaurant = ReservationRestaurant.fromJson(json['restaurantId']);
      restId = restaurant.id;
    } else {
      restId = json['restaurantId']?.toString();
    }

    return ReservationModel(
      id: json['_id']?.toString(),
      userId: json['userId']?.toString(),
      restaurantId: restId,
      restaurant: restaurant,
      date: json['date'] != null ? DateTime.tryParse(json['date'].toString()) : null,
      timeSlot: json['timeSlot']?.toString(),
      numberOfGuests: json['numberOfGuests'],
      tableId: json['tableId']?.toString(),
      roomId: json['roomId']?.toString(),
      areaPreference: json['areaPreference']?.toString(),
      reservationType: json['reservationType']?.toString() ?? 'table',
      status: json['status']?.toString() ?? 'Pending',
      specialRequests: json['specialRequests']?.toString(),
      tableDetails: json['tableDetails'] != null
          ? TableDetails.fromJson(json['tableDetails'])
          : null,
      roomDetails: json['roomDetails'] != null
          ? RoomDetails.fromJson(json['roomDetails'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'restaurantId': restaurantId,
        'date': date?.toIso8601String(),
        'timeSlot': timeSlot,
        'numberOfGuests': numberOfGuests,
        if (tableId != null) 'tableId': tableId,
        if (roomId != null) 'roomId': roomId,
        if (areaPreference != null) 'areaPreference': areaPreference,
        'reservationType': reservationType,
        if (specialRequests != null && specialRequests!.isNotEmpty)
          'specialRequests': specialRequests,
      };
}

class ReservationRestaurant {
  final String? id;
  final String? title;
  final String? imageUrl;
  final String? logoUrl;

  ReservationRestaurant({this.id, this.title, this.imageUrl, this.logoUrl});

  factory ReservationRestaurant.fromJson(Map<String, dynamic> json) =>
      ReservationRestaurant(
        id: json['_id']?.toString(),
        title: json['title']?.toString(),
        imageUrl: json['imageUrl']?.toString(),
        logoUrl: json['logoUrl']?.toString(),
      );
}

class TableDetails {
  final String? id;
  final int? tableNumber;
  final int? capacity;
  final String? area;
  final String? description;

  TableDetails({this.id, this.tableNumber, this.capacity, this.area, this.description});

  factory TableDetails.fromJson(Map<String, dynamic> json) => TableDetails(
        id: json['_id']?.toString() ?? json['id']?.toString(),
        tableNumber: json['tableNumber'],
        capacity: json['capacity'],
        area: json['area']?.toString(),
        description: json['description']?.toString(),
      );
}

class RoomDetails {
  final String? id;
  final int? roomNumber;
  final int? capacity;
  final String? area;
  final String? description;
  final List<String>? amenities;

  RoomDetails({this.id, this.roomNumber, this.capacity, this.area, this.description, this.amenities});

  factory RoomDetails.fromJson(Map<String, dynamic> json) => RoomDetails(
        id: json['_id']?.toString() ?? json['id']?.toString(),
        roomNumber: json['roomNumber'],
        capacity: json['capacity'],
        area: json['area']?.toString(),
        description: json['description']?.toString(),
        amenities: json['amenities'] == null
            ? null
            : List<String>.from(json['amenities']!.map((x) => x.toString())),
      );
}

class TimeSlotInfo {
  final String timeSlot;
  final int available;
  final int total;
  final bool isAvailable;

  TimeSlotInfo({
    required this.timeSlot,
    required this.available,
    required this.total,
    required this.isAvailable,
  });

  factory TimeSlotInfo.fromJson(Map<String, dynamic> json) => TimeSlotInfo(
        timeSlot: json['timeSlot']?.toString() ?? '',
        available: json['available'] ?? 0,
        total: json['total'] ?? 0,
        isAvailable: json['isAvailable'] ?? false,
      );
}

class ReservationSlotsResponse {
  final String? date;
  final List<TimeSlotInfo> slots;
  final ReservationRestaurantInfo? restaurant;

  ReservationSlotsResponse({this.date, this.slots = const [], this.restaurant});

  factory ReservationSlotsResponse.fromJson(Map<String, dynamic> json) =>
      ReservationSlotsResponse(
        date: json['date']?.toString(),
        slots: json['slots'] == null
            ? []
            : List<TimeSlotInfo>.from(
                json['slots']!.map((x) => TimeSlotInfo.fromJson(x)),
              ),
        restaurant: json['restaurant'] != null
            ? ReservationRestaurantInfo.fromJson(json['restaurant'])
            : null,
      );
}

class ReservationRestaurantInfo {
  final String? id;
  final String? title;
  final int totalTables;
  final int totalRooms;
  final int totalSeatingCapacity;
  final int maxTableCapacity;
  final int maxRoomCapacity;
  final List<String> seatingAreas;
  final List<TableInfo> tables;
  final List<RoomInfo> rooms;

  ReservationRestaurantInfo({
    this.id,
    this.title,
    this.totalTables = 0,
    this.totalRooms = 0,
    this.totalSeatingCapacity = 0,
    this.maxTableCapacity = 0,
    this.maxRoomCapacity = 0,
    this.seatingAreas = const [],
    this.tables = const [],
    this.rooms = const [],
  });

  factory ReservationRestaurantInfo.fromJson(Map<String, dynamic> json) =>
      ReservationRestaurantInfo(
        id: json['id']?.toString() ?? json['_id']?.toString(),
        title: json['title']?.toString(),
        totalTables: json['totalTables'] ?? 0,
        totalRooms: json['totalRooms'] ?? 0,
        totalSeatingCapacity: json['totalSeatingCapacity'] ?? 0,
        maxTableCapacity: json['maxTableCapacity'] ?? 0,
        maxRoomCapacity: json['maxRoomCapacity'] ?? 0,
        seatingAreas: json['seatingAreas'] == null
            ? []
            : List<String>.from(json['seatingAreas']!.map((x) => x.toString())),
        tables: json['tables'] == null
            ? []
            : List<TableInfo>.from(
                json['tables']!.map((x) => TableInfo.fromJson(x)),
              ),
        rooms: json['rooms'] == null
            ? []
            : List<RoomInfo>.from(
                json['rooms']!.map((x) => RoomInfo.fromJson(x)),
              ),
      );
}

class TableInfo {
  final String? id;
  final int? tableNumber;
  final int? capacity;
  final String? area;
  final String? description;
  final bool isAvailable;

  TableInfo({
    this.id,
    this.tableNumber,
    this.capacity,
    this.area,
    this.description,
    this.isAvailable = true,
  });

  factory TableInfo.fromJson(Map<String, dynamic> json) => TableInfo(
        id: json['id']?.toString() ?? json['_id']?.toString(),
        tableNumber: json['tableNumber'],
        capacity: json['capacity'],
        area: json['area']?.toString(),
        description: json['description']?.toString(),
        isAvailable: json['isAvailable'] ?? true,
      );
}

class RoomInfo {
  final String? id;
  final int? roomNumber;
  final int? capacity;
  final String? area;
  final String? description;
  final bool isAvailable;
  final List<String> amenities;

  RoomInfo({
    this.id,
    this.roomNumber,
    this.capacity,
    this.area,
    this.description,
    this.isAvailable = true,
    this.amenities = const [],
  });

  factory RoomInfo.fromJson(Map<String, dynamic> json) => RoomInfo(
        id: json['id']?.toString() ?? json['_id']?.toString(),
        roomNumber: json['roomNumber'],
        capacity: json['capacity'],
        area: json['area']?.toString(),
        description: json['description']?.toString(),
        isAvailable: json['isAvailable'] ?? true,
        amenities: json['amenities'] == null
            ? []
            : List<String>.from(json['amenities']!.map((x) => x.toString())),
      );
}
