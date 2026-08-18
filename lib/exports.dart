// Flutter & Dart
export 'package:flutter/material.dart';
export 'package:flutter/services.dart';

// Firebase
export 'package:firebase_core/firebase_core.dart';
export 'package:cloud_firestore/cloud_firestore.dart';

// State Management
export 'package:flutter_bloc/flutter_bloc.dart';

// Local Storage
export 'package:hive_flutter/hive_flutter.dart';

// Dependency Injection
export 'package:get_it/get_it.dart';

// Network
export 'package:connectivity_plus/connectivity_plus.dart';

// Utils
export 'package:intl/intl.dart' hide TextDirection;
export 'package:uuid/uuid.dart';
export 'package:google_fonts/google_fonts.dart';
export 'package:talker/talker.dart';
export 'package:talker_flutter/talker_flutter.dart';
export 'package:talker_bloc_logger/talker_bloc_logger.dart';
export 'package:shimmer/shimmer.dart';

export 'package:flutter_screenutil/flutter_screenutil.dart';

// Core - Constants
export 'core/constants/app_constants.dart';
export 'core/constants/app_durations.dart';
export 'core/constants/app_images.dart';
export 'core/constants/app_sizes.dart';
export 'core/constants/app_strings.dart';
export 'core/constants/enums.dart';

// Core - Error
export 'core/error/exceptions.dart';
export 'core/error/failures.dart';

// Core - Network
export 'core/network/network_info.dart';

// Core - Theme
export 'core/theme/app_colors.dart';
export 'core/theme/theme_cubit.dart';

// Core - Utils
export 'core/utils/date_formatter.dart';
export 'core/utils/app_logger.dart';

// Core - Widgets
export 'core/widgets/app_toast.dart';
export 'core/widgets/app_page_route.dart';
export 'core/widgets/animated_appear.dart';
export 'core/widgets/delete_confirm_dialog.dart';

// Domain - Entities
export 'features/task/domain/entities/task_entity.dart';

// Domain - Repositories
export 'features/task/domain/repositories/task_repository.dart';

// Domain - Usecases
export 'features/task/domain/usecases/create_task.dart';
export 'features/task/domain/usecases/delete_task.dart';
export 'features/task/domain/usecases/get_tasks.dart';
export 'features/task/domain/usecases/sync_tasks.dart';
export 'features/task/domain/usecases/toggle_task_status.dart';
export 'features/task/domain/usecases/update_task.dart';

// Data - Models
export 'features/task/data/models/task_model.dart';

// Data - Datasources
export 'features/task/data/datasources/task_local_data_source.dart';
export 'features/task/data/datasources/task_remote_data_source.dart';

// Data - Repositories
export 'features/task/data/repositories/task_repository_impl.dart';

// Presentation - BLoC
export 'features/task/presentation/bloc/task_bloc.dart';
export 'features/task/presentation/bloc/task_event.dart';
export 'features/task/presentation/bloc/task_state.dart';

// Presentation - Pages
export 'features/task/presentation/pages/add_edit_task_page.dart';
export 'features/task/presentation/pages/splash_page.dart';
export 'features/task/presentation/pages/task_detail_page.dart';
export 'features/task/presentation/pages/task_list_page.dart';

// Presentation - Widgets
export 'features/task/presentation/widgets/empty_state_widget.dart';
export 'features/task/presentation/widgets/filter_sort_bar.dart';
export 'features/task/presentation/widgets/sync_indicator.dart';
export 'features/task/presentation/widgets/task_card.dart';
export 'features/task/presentation/widgets/task_list_shimmer.dart';

// App
export 'app/app.dart';
export 'app/di/injection.dart';
export 'app/router/app_router.dart';
export 'app/theme/app_theme.dart';
