import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/event_model.dart';
import '../../repositories/event_repository.dart';

sealed class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {
  const EventsInitial();
}

class EventsLoading extends EventsState {
  const EventsLoading();
}

class EventsLoaded extends EventsState {
  const EventsLoaded(this.events);

  final List<EventModel> events;

  @override
  List<Object?> get props => [events];
}

class EventsError extends EventsState {
  const EventsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class EventsCubit extends Cubit<EventsState> {
  EventsCubit(this._repository)
      : super(const EventsInitial());

  final EventRepository _repository;

  Future<void> loadEvents() async {
    emit(const EventsLoading());

    try {
      // Get events from Firebase through the repository.
      final events = await _repository.getEvents();

      emit(EventsLoaded(events));
    } catch (e, stackTrace) {
      // Print the real Firebase/model error to the debug console.
      debugPrint('EVENTS ERROR: $e');
      debugPrint('EVENTS STACK TRACE: $stackTrace');

      emit(
        EventsError(
          'Unable to load events.\n\n$e',
        ),
      );
    }
  }
}