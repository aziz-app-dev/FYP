import 'package:equatable/equatable.dart';

import '../../../model/reservation/reservation_model.dart';

enum ReservationStatus {
  initial,
  loadingInfo,
  loadingSlots,
  loaded,
  submitting,
  submitSuccess,
  loadingReservations,
  reservationsLoaded,
  cancelling,
  error,
}

class ReservationState extends Equatable {
  final ReservationStatus status;
  final ReservationRestaurantInfo? restaurantInfo;
  final List<TimeSlotInfo> availableSlots;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final int selectedGuests;
  final String? selectedArea;
  final String selectedType;
  final List<ReservationModel> userReservations;
  final String? errorMessage;
  final String? successMessage;

  const ReservationState({
    this.status = ReservationStatus.initial,
    this.restaurantInfo,
    this.availableSlots = const [],
    this.selectedDate,
    this.selectedTimeSlot,
    this.selectedGuests = 2,
    this.selectedArea,
    this.selectedType = 'table',
    this.userReservations = const [],
    this.errorMessage,
    this.successMessage,
  });

  bool get isLoadingInfo => status == ReservationStatus.loadingInfo;
  bool get isLoadingSlots => status == ReservationStatus.loadingSlots;
  bool get isLoaded => status == ReservationStatus.loaded;
  bool get isSubmitting => status == ReservationStatus.submitting;
  bool get isSubmitSuccess => status == ReservationStatus.submitSuccess;
  bool get isLoadingReservations => status == ReservationStatus.loadingReservations;
  bool get isReservationsLoaded => status == ReservationStatus.reservationsLoaded;
  bool get hasError => status == ReservationStatus.error;

  bool get canSubmit =>
      selectedDate != null &&
      selectedTimeSlot != null &&
      selectedGuests > 0;

  List<ReservationModel> get upcomingReservations => userReservations
      .where((r) => r.isUpcoming)
      .toList();

  List<ReservationModel> get pastReservations => userReservations
      .where((r) => !r.isUpcoming)
      .toList();

  ReservationState copyWith({
    ReservationStatus? status,
    ReservationRestaurantInfo? restaurantInfo,
    List<TimeSlotInfo>? availableSlots,
    DateTime? selectedDate,
    String? selectedTimeSlot,
    int? selectedGuests,
    String? selectedArea,
    String? selectedType,
    List<ReservationModel>? userReservations,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearTimeSlot = false,
    bool clearArea = false,
  }) {
    return ReservationState(
      status: status ?? this.status,
      restaurantInfo: restaurantInfo ?? this.restaurantInfo,
      availableSlots: availableSlots ?? this.availableSlots,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: clearTimeSlot ? null : (selectedTimeSlot ?? this.selectedTimeSlot),
      selectedGuests: selectedGuests ?? this.selectedGuests,
      selectedArea: clearArea ? null : (selectedArea ?? this.selectedArea),
      selectedType: selectedType ?? this.selectedType,
      userReservations: userReservations ?? this.userReservations,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
        status,
        restaurantInfo,
        availableSlots,
        selectedDate,
        selectedTimeSlot,
        selectedGuests,
        selectedArea,
        selectedType,
        userReservations,
        errorMessage,
        successMessage,
      ];
}
