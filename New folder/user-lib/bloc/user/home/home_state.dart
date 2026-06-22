import 'package:equatable/equatable.dart';
import '../../../data/api/api_reospes.dart';
import '../../../model/home/home_model.dart';

class HomeStates extends Equatable {
  final ApiResponse<HomeData> homeData;

  const HomeStates({
    required this.homeData,
  });

  HomeStates copyWith({
    ApiResponse<HomeData>? homeData,
  }) {
    return HomeStates(
      homeData: homeData ?? this.homeData,
    );
  }

  @override
  List<Object?> get props => [homeData];
}
