import 'package:equatable/equatable.dart';
import '../../../data/api/api_reospes.dart';
import '../../../model/movies_model.dart';

class MoviesState extends Equatable {
  final ApiResponse<MoviesModel> moviesList;

  const MoviesState({required this.moviesList});

  MoviesState copyWith({ApiResponse<MoviesModel>? moviesList}) {
    return MoviesState(moviesList: moviesList ?? this.moviesList);
  }

  @override
  List<Object?> get props => [moviesList];
}
