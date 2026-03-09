import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gig_model.dart';
import '../repositories/mock_repository.dart';

class GigState {
  final bool isLoading;
  final List<GigModel> gigs;
  final GigModel? selectedGig;
  final String? error;
  final String searchQuery;
  final List<String> filterSkills;

  const GigState({
    this.isLoading = false,
    this.gigs = const [],
    this.selectedGig,
    this.error,
    this.searchQuery = '',
    this.filterSkills = const [],
  });

  GigState copyWith({
    bool? isLoading,
    List<GigModel>? gigs,
    GigModel? selectedGig,
    String? error,
    String? searchQuery,
    List<String>? filterSkills,
  }) {
    return GigState(
      isLoading: isLoading ?? this.isLoading,
      gigs: gigs ?? this.gigs,
      selectedGig: selectedGig ?? this.selectedGig,
      error: error,
      searchQuery: searchQuery ?? this.searchQuery,
      filterSkills: filterSkills ?? this.filterSkills,
    );
  }

  List<GigModel> get filteredGigs {
    var filtered = gigs.where((g) => g.isPublished).toList();
    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where((g) =>
              g.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              g.location.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    if (filterSkills.isNotEmpty) {
      filtered = filtered
          .where((g) => g.requiredSkills.any((s) => filterSkills.contains(s)))
          .toList();
    }
    return filtered;
  }
}

class GigNotifier extends StateNotifier<GigState> {
  GigNotifier() : super(const GigState());

  Future<void> loadGigs() async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      isLoading: false,
      gigs: MockRepository.mockGigs,
    );
  }

  void selectGig(GigModel gig) {
    state = state.copyWith(selectedGig: gig);
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setFilterSkills(List<String> skills) {
    state = state.copyWith(filterSkills: skills);
  }

  Future<bool> createGig(GigModel gig) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    state = state.copyWith(
      isLoading: false,
      gigs: [...state.gigs, gig],
    );
    return true;
  }

  Future<bool> publishGig(String gigId) async {
    state = state.copyWith(isLoading: true);
    await Future.delayed(const Duration(milliseconds: 300));
    final updated = state.gigs.map((g) {
      if (g.id == gigId) return g.copyWith(status: 'published');
      return g;
    }).toList();
    state = state.copyWith(isLoading: false, gigs: updated);
    return true;
  }
}

final gigProvider = StateNotifierProvider<GigNotifier, GigState>((ref) {
  return GigNotifier();
});
