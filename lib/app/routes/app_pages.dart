import 'package:get/get.dart';

import '../modules/budget/bindings/budget_binding.dart';
import '../modules/budget/views/budget_view.dart';
import '../modules/budget_detail/bindings/budget_detail_binding.dart';
import '../modules/budget_detail/views/budget_detail_view.dart';
import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/chat_detail/bindings/chat_detail_binding.dart';
import '../modules/chat_detail/views/chat_detail_view.dart';
import '../modules/check_in/bindings/check_in_binding.dart';
import '../modules/check_in/views/check_in_view.dart';
import '../modules/check_in_detail/bindings/check_in_detail_binding.dart';
import '../modules/check_in_detail/views/check_in_detail_view.dart';
import '../modules/create_budget/bindings/create_budget_binding.dart';
import '../modules/create_budget/views/create_budget_view.dart';
import '../modules/create_request/bindings/create_request_binding.dart';
import '../modules/create_request/views/create_request_view.dart';
import '../modules/edit-description/bindings/edit_description_binding.dart';
import '../modules/edit-description/views/edit_description_view.dart';
import '../modules/edit_request/bindings/edit_request_binding.dart';
import '../modules/edit_request/views/edit_request_view.dart';
import '../modules/event_detail/bindings/event_detail_binding.dart';
import '../modules/event_detail/views/event_detail_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/otp/bindings/otp_binding.dart';
import '../modules/otp/views/otp_view.dart';
import '../modules/policy/bindings/policy_binding.dart';
import '../modules/policy/views/policy_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile_chat/bindings/profile_chat_binding.dart';
import '../modules/profile_chat/views/profile_chat_view.dart';
import '../modules/request_detail/bindings/request_detail_binding.dart';
import '../modules/request_detail/views/request_detail_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/reset_password_successfully/bindings/reset_password_successfully_binding.dart';
import '../modules/reset_password_successfully/views/reset_password_successfully_view.dart';
import '../modules/splash-screen/bindings/splash_screen_binding.dart';
import '../modules/splash-screen/views/splash_screen_view.dart';
import '../modules/statistics/bindings/statistics_binding.dart';
import '../modules/statistics/views/statistics_view.dart';
import '../modules/subtask-detail-view/bindings/subtask_detail_view_binding.dart';
import '../modules/subtask-detail-view/views/subtask_detail_view_view.dart';
import '../modules/tab_view/bindings/tab_view_binding.dart';
import '../modules/tab_view/views/tab_view_view.dart';
import '../modules/task-detail-view/bindings/task_detail_view_binding.dart';
import '../modules/task-detail-view/views/task_detail_view_view.dart';
import '../modules/task-overall-view/bindings/task_overall_view_binding.dart';
import '../modules/task-overall-view/views/task_overall_view_view.dart';
import '../modules/task_schedule/bindings/task_schedule_binding.dart';
import '../modules/task_schedule/views/task_schedule_view.dart';
import '../modules/timeline_reassign/bindings/timeline_reassign_binding.dart';
import '../modules/timeline_reassign/views/timeline_reassign_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.TAB_VIEW,
      page: () => const TabViewView(),
      binding: TabViewBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.OTP,
      page: () => const OtpView(),
      binding: OtpBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.RESET_PASSWORD_SUCCESSFULLY,
      page: () => const ResetPasswordSuccessfullyView(),
      binding: ResetPasswordSuccessfullyBinding(),
    ),
    GetPage(
      name: _Paths.TASK_OVERALL_VIEW,
      page: () => const TaskOverallViewView(),
      binding: TaskOverallViewBinding(),
    ),
    GetPage(
      name: _Paths.TASK_DETAIL_VIEW,
      page: () => const TaskDetailViewView(),
      binding: TaskDetailViewBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_DESCRIPTION,
      page: () => EditDescriptionView(),
      binding: EditDescriptionBinding(),
    ),
    GetPage(
      name: _Paths.SUBTASK_DETAIL_VIEW,
      page: () => const SubtaskDetailViewView(),
      binding: SubtaskDetailViewBinding(),
    ),
    GetPage(
      name: _Paths.BUDGET,
      page: () => const BudgetView(),
      binding: BudgetBinding(),
    ),
    GetPage(
      name: _Paths.BUDGET_DETAIL,
      page: () => const BudgetDetailView(),
      binding: BudgetDetailBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_BUDGET,
      page: () => const CreateBudgetView(),
      binding: CreateBudgetBinding(),
    ),
    GetPage(
      name: _Paths.EVENT_DETAIL,
      page: () => const EventDetailView(),
      binding: EventDetailBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_REQUEST,
      page: () => const CreateRequestView(),
      binding: CreateRequestBinding(),
    ),
    GetPage(
      name: _Paths.REQUEST_DETAIL,
      page: () => const RequestDetailView(),
      binding: RequestDetailBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_REQUEST,
      page: () => const EditRequestView(),
      binding: EditRequestBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.POLICY,
      page: () => const PolicyView(),
      binding: PolicyBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_IN,
      page: () => const CheckInView(),
      binding: CheckInBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_IN_DETAIL,
      page: () => const CheckInDetailView(),
      binding: CheckInDetailBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_DETAIL,
      page: () => const ChatDetailView(),
      binding: ChatDetailBinding(),
    ),
    GetPage(
      name: _Paths.TASK_SCHEDULE,
      page: () => const TaskScheduleView(),
      binding: TaskScheduleBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE_CHAT,
      page: () => const ProfileChatView(),
      binding: ProfileChatBinding(),
    ),
    GetPage(
      name: _Paths.TIMELINE_REASSIGN,
      page: () => const TimelineReassignView(),
      binding: TimelineReassignBinding(),
    ),
    GetPage(
      name: _Paths.STATISTICS,
      page: () => const StatisticsView(),
      binding: StatisticsBinding(),
    ),
  ];
}
