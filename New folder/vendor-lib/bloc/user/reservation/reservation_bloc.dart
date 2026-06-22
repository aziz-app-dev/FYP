import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../model/reservation/reservation_model.dart';
import '../../../repo/user/reservation/reservation_repo.dart';
import 'reservation_event.dart';
import 'reservation_state.dart';

class ReservationBloc extends Bloc<ReservationEvent, ReservationState> {
  final ReservationRepo reservationRepo;

  ReservationBloc({required this.reservationRepo})
      : super(const ReservationState()) {
    on<LoadReservationInfoEvent>(_onLoadInfo);
    on<LoadAvailableSlotsEvent>(_onLoadSlots);
    on<SelectDateEvent>(_onSelectDate);
    on<SelectTimeSlotEvent>(_onSelectTimeSlot);
    on<SelectGuestsEvent>(_onSelectGuests);
    on<SelectAreaEvent>(_onSelectArea);
    on<SelectTypeEvent>(_onSelectType);
    on<CreateReservationEvent>(_onCreateReservation);
    on<LoadUserReservationsEvent>(_onLoadUserReservations);
    on<CancelReservationEvent>(_onCancelReservation);
  }

  Future<void> _onLoadInfo(
    LoadReservationInfoEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(state.copyWith(status: ReservationStatus.loadingInfo, clearError: true));

    final response = await reservationRepo.getRestaurantReservationInfo(event.restaurantId);

    if (response.success && response.info != null) {
      emit(state.copyWith(
        status: ReservationStatus.loaded,
        restaurantInfo: response.info,
      ));
    } else {
      emit(state.copyWith(
        status: ReservationStatus.error,
        errorMessage: response.message,
      ));
    }
  }

  Future<void> _onLoadSlots(
    LoadAvailableSlotsEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(state.copyWith(status: ReservationStatus.loadingSlots, clearError: true));

    final response = await reservationRepo.getAvailableSlots(
      restaurantId: event.restaurantId,
      date: event.date,
      guests: event.guests,
      area: event.area,
      type: event.type,
    );

    if (response.success && response.data != null) {
      emit(state.copyWith(
        status: ReservationStatus.loaded,
        availableSlots: response.data!.slots,
        restaurantInfo: response.data!.restaurant ?? state.restaurantInfo,
        clearTimeSlot: true,
      ));
    } else {
      emit(state.copyWith(
        status: ReservationStatus.error,
        errorMessage: response.message,
      ));
    }
  }

  void _onSelectDate(SelectDateEvent event, Emitter<ReservationState> emit) {
    emit(state.copyWith(
      selectedDate: event.date,
      clearTimeSlot: true,
    ));
  }

  void _onSelectTimeSlot(
    SelectTimeSlotEvent event,
    Emitter<ReservationState> emit,
  ) {
    emit(state.copyWith(selectedTimeSlot: event.timeSlot));
  }

  void _onSelectGuests(
    SelectGuestsEvent event,
    Emitter<ReservationState> emit,
  ) {
    emit(state.copyWith(selectedGuests: event.guests));
  }

  void _onSelectArea(SelectAreaEvent event, Emitter<ReservationState> emit) {
    emit(state.copyWith(
      selectedArea: event.area,
      clearArea: event.area == null,
    ));
  }

  void _onSelectType(SelectTypeEvent event, Emitter<ReservationState> emit) {
    emit(state.copyWith(
      selectedType: event.type,
      clearTimeSlot: true,
      clearArea: true,
    ));
  }

  Future<void> _onCreateReservation(
    CreateReservationEvent event,
    Emitter<ReservationState> emit,
  ) async {
    if (!state.canSubmit) return;

    emit(state.copyWith(status: ReservationStatus.submitting, clearError: true));

    final data = {
      'restaurantId': event.restaurantId,
      'date': DateFormat('yyyy-MM-dd').format(state.selectedDate!),
      'timeSlot': state.selectedTimeSlot,
      'numberOfGuests': state.selectedGuests,
      'reservationType': state.selectedType,
      if (state.selectedArea != null) 'areaPreference': state.selectedArea,
      if (event.specialRequests != null && event.specialRequests!.isNotEmpty)
        'specialRequests': event.specialRequests,
    };

    final response = await reservationRepo.createReservation(data);

    if (response.success) {
      emit(state.copyWith(
        status: ReservationStatus.submitSuccess,
        successMessage: response.message ?? 'Reservation created successfully',
      ));
    } else {
      emit(state.copyWith(
        status: ReservationStatus.error,
        errorMessage: response.message,
      ));
    }
  }

  Future<void> _onLoadUserReservations(
    LoadUserReservationsEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(state.copyWith(
      status: ReservationStatus.loadingReservations,
      clearError: true,
    ));

    final response = await reservationRepo.getUserReservations(status: event.status);

    if (response.success) {
      emit(state.copyWith(
        status: ReservationStatus.reservationsLoaded,
        userReservations: response.reservations,
      ));
    } else {
      emit(state.copyWith(
        status: ReservationStatus.error,
        errorMessage: response.message,
      ));
    }
  }

  Future<void> _onCancelReservation(
    CancelReservationEvent event,
    Emitter<ReservationState> emit,
  ) async {
    emit(state.copyWith(status: ReservationStatus.cancelling, clearError: true));

    final response = await reservationRepo.cancelReservation(event.reservationId);

    if (response.success) {
      final updated = state.userReservations.map((r) {
        if (r.id == event.reservationId) {
          return ReservationModel.fromJson({
            ...r.toJson(),
            '_id': r.id,
            'status': 'Cancelled',
          });
        }
        return r;
      }).toList();

      emit(state.copyWith(
        status: ReservationStatus.reservationsLoaded,
        userReservations: updated,
        successMessage: 'Reservation cancelled',
      ));
    } else {
      emit(state.copyWith(
        status: ReservationStatus.error,
        errorMessage: response.message,
      ));
    }
  }
}
