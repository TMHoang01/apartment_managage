import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:apartment_managage/domain/models/ecom/category_model.dart';
import 'package:apartment_managage/domain/repository/ecom/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  late List<Category> categories;
  final CategoryRepository categoryRepository;
  CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) {});

    on<GetCategoriesEvent>((event, emit) => _onFetchCategories(event, emit));
  }

  _onFetchCategories(
      GetCategoriesEvent event, Emitter<CategoryState> emit) async {
    {
      emit(CategoryLoading());
      try {
        categories = await categoryRepository.getAll();
        emit(CategoryLoaded(categories));
      } catch (e) {
        emit(CategoryError(e.toString()));
      }
    }
  }
}
