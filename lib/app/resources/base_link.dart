class BaseLink {
  static const localBaseLink = 'http://api.hreaevent.live';
  static const socketIO = 'http://14.225.204.176:3006';

  static const login = '/api/v1/auth/login';
  static const storeDevice = '/api/v1/device';
  static const sendOtp = '/api/v1/auth/send-code';
  static const verifyCode = '/api/v1/auth/verify-code';
  static const resetPassword = '/api/v1/auth/forget-password';
  static const changePassword = '/api/v1/auth/change-password';
  static const getProfile = '/api/v1/user/profile';
  static const updateProfile = '/api/v1/user/profile';
  static const uploadFile = '/api/v1/file/upload';
  static const getEvent = '/api/v1/event/division';
  static const getTask = '/api/v1/task';
  static const getTaskBySelf = '/api/v1/task/filterByAssignee';
  static const getAssignerInformation = '/api/v1/user/';
  static const updateStatusTask = '/api/v1/task/updateTaskStatus';
  static const updateFileTask = '/api/v1/taskFile';
  static const updateTask = '/api/v1/task/updateTask';
  static const updateTaskFile = '/api/v1/taskFile/';
  static const createSubTask = '/api/v1/task/createTask';
  static const createComment = '/api/v1/comment';
  static const getAllEmployee = '/api/v1/user';
  static const assignTask = '/api/v1/assign-task';
  static const getAllComment = '/api/v1/comment';
  static const deleteComment = '/api/v1/comment/';
  static const updateCommentFile = '/api/v1/commentfile/';
  static const updateComment = '/api/v1/comment/';
  static const createBudget = '/api/v1/budget';
  static const getAllBudget = '/api/v1/budget';
  static const updateBudget = '/api/v1/budget/';
  static const deleteBudget = '/api/v1/budget/detail/';
  static const getBudgetDetail = '/api/v1/budget/detail/';
  static const getEventDetail = '/api/v1/event/';
  static const createLeaveRequest = '/api/v1/request';
  static const getAllLeaveRequest = '/api/v1/request/filterRequest/';
  static const getLeaveRequestDetail = '/api/v1/request/detail/';
  static const updateLeaveRequest = '/api/v1/request/changeRequest/';
  static const deleteLeaveRequest = '/api/v1/request/changeRequest/';
  static const getAllNotification = '/api/v1/notification';
  static const seenANotification = '/api/v1/notification/seen';
  static const seenAllNotification = '/api/v1/notification/seen-all';
  static const checkIn = '/api/v1/timesheet/check-in';
  static const getDetailTimesheet = '/api/v1/timesheet';
  static const deleteNotification = '/api/v1/notification/delete/';
  static const deleteAllNotification = '/api/v1/notification/delete-all';
}