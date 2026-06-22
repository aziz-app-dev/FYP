abstract class ReservationEvent {
  const ReservationEvent();
}

class LoadReservationInfoEvent extends ReservationEvent {
  final String restaurantId;
  const LoadReservationInfoEvent({required this.restaurantId});
}

class LoadAvailableSlotsEvent extends ReservationEvent {
  final String restaurantId;
  final String date;
  final int guests;
  final String? area;
  final String type;

  const LoadAvailableSlotsEvent({
    required this.restaurantId,
    required this.date,
    this.guests = 1,
    this.area,
    this.type = 'table',
  });
}

class SelectDateEvent extends ReservationEvent {
  final DateTime date;
  const SelectDateEvent({required this.date});
}

class SelectTimeSlotEvent extends ReservationEvent {
  final String timeSlot;
  const SelectTimeSlotEvent({required this.timeSlot});
}

class SelectGuestsEvent extends ReservationEvent {
  final int guests;
  const SelectGuestsEvent({required this.guests});
}

class SelectAreaEvent extends ReservationEvent {
  final String? area;
  const SelectAreaEvent({this.area});
}

class SelectTypeEvent extends ReservationEvent {
  final String type;
  const SelectTypeEvent({required this.type});
}

class CreateReservationEvent extends ReservationEvent {
  final String restaurantId;
  final String? specialRequests;
  const CreateReservationEvent({
    required this.restaurantId,
    this.specialRequests,
  });
}

class LoadUserReservationsEvent extends ReservationEvent {
  final String? status;
  const LoadUserReservationsEvent({this.status});
}

class CancelReservationEvent extends ReservationEvent {
  final String reservationId;
  const CancelReservationEvent({required this.reservationId});
}
