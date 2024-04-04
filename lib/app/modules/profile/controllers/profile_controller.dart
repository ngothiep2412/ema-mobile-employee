import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrea_mobile_employee/app/base/base_controller.dart';
import 'package:hrea_mobile_employee/app/modules/profile/api/profile_api.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/controllers/tab_setting_controller/tab_setting_controller.dart';
import 'package:hrea_mobile_employee/app/modules/tab_view/model/user_model.dart';
import 'package:hrea_mobile_employee/app/modules/task-detail-view/model/uploadfile_model.dart';
import 'package:hrea_mobile_employee/app/resources/response_api_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileController extends BaseController {
  ProfileController({required this.userModel});

  TextEditingController? fullNameController;
  TextEditingController? phoneController;
  TextEditingController? addressController;
  TextEditingController? dateController;
  RxString imageUrl = ''.obs;

  ImagePicker imagePicker = ImagePicker();
  File? imageFile;
  XFile? file;
  String? userForm;
  UserModel? userModel;
  Rx<UserModel> userModelView = UserModel().obs;

  ResponseApi? responseApi;
  RxString selectImagePath = ''.obs;
  RxString selectImageSize = ''.obs;

  // var user = GetStorage().read('user');
  RxBool errorUpdateProfile = false.obs;
  RxString errorUpdateProfileText = ''.obs;
  RxBool isLoading = false.obs;

  var selectedDate = DateTime.now().obs;
  final genderList = ["Nam", "Nữ"];
  RxString selectedGenderVal = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    try {
      // print('user ${user}');
      // Map<String, dynamic> userMap = jsonDecode(GetStorage().read('user'));
      // userModel = UserModel.fromJson(userMap);
      userModelView.value = userModel!;
      print('userForm ${userModelView.value.result!.fullName}');

      dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(userModelView.value.result!.dob!));
      fullNameController = TextEditingController(text: userModelView.value.result!.fullName);
      // emailController = TextEditingController(text: userModel!.result!.email);
      addressController = TextEditingController(text: userModelView.value.result!.address);
      phoneController = TextEditingController(text: userModelView.value.result!.phoneNumber);
      imageUrl.value = userModelView.value.result!.avatar!;
      selectedGenderVal.value = userModelView.value.result!.gender!;
    } catch (e) {
      print('Error parsing JSON: $e');
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> updateProfile() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    if (fullNameController!.text == '') {
      print(fullNameController!.text);
      errorUpdateProfile.value = true;
      errorUpdateProfileText.value = "Vui lòng nhập họ và tên";
      isLoading.value = false;
    } else if (phoneController!.text == '') {
      errorUpdateProfile.value = true;
      errorUpdateProfileText.value = "Vui lòng nhập số điện thoại";
      isLoading.value = false;
    } else if (isValidPhoneNumber(phoneController!.text) == false) {
      errorUpdateProfile.value = true;
      errorUpdateProfileText.value = "Số điện thoại không hợp lệ";
      isLoading.value = false;
    } else if (isDateValid(dateController!.text) != true) {
      errorUpdateProfile.value = true;
      errorUpdateProfileText.value = "Ngày sinh không hợp lệ, nhập đúng định dạng dd/mm/yyyy";
      isLoading.value = false;
    } else {
      try {
        // String? jwtToken = pref.getString('JWT');
        String? jwtToken = GetStorage().read('JWT');
        String gender = 'MALE';
        if (selectedGenderVal.value == 'Nữ') {
          gender = 'FEMALE';
        }
        if (jwtToken != null) {
          if (imageFile == null) {
            List<String> parts = dateController!.text.split('/');
            String formattedDate = '${parts[2]}-${parts[1]}-${parts[0]}';
            responseApi = await ProfileApi.updateProfile(phoneController!.text, fullNameController!.text, DateTime.parse(formattedDate),
                addressController!.text, imageUrl.value, gender, jwtToken);
            if (responseApi!.statusCode == 200 || responseApi!.statusCode == 201) {
              errorUpdateProfile.value = false;
              await Get.find<TabSettingController>().getProfile();
            } else {
              errorUpdateProfile.value = true;
              errorUpdateProfileText.value = "Không thể cập nhật thông tin";
            }
          } else {
            UploadFileModel responseApi = await ProfileApi.uploadFile(jwtToken, file!);
            if (responseApi.statusCode == 200 || responseApi.statusCode == 201) {
              List<String> parts = dateController!.text.split('/');
              String formattedDate = '${parts[2]}-${parts[1]}-${parts[0]}';

              ResponseApi responseApiv2 = await ProfileApi.updateProfile(phoneController!.text, fullNameController!.text,
                  DateTime.parse(formattedDate), addressController!.text, responseApi.result!.downloadUrl!, gender, jwtToken);
              if (responseApiv2.statusCode == 200 || responseApiv2.statusCode == 201) {
                errorUpdateProfile.value = false;
                await Get.find<TabSettingController>().getProfile();
              } else {
                errorUpdateProfile.value = true;
                errorUpdateProfileText.value = "Không thể cập nhật thông tin";
              }
            } else {
              errorUpdateProfile.value = true;
              errorUpdateProfileText.value = "Kích thước file phải nhỏ hơn 10mb";
            }
          }
          isLoading.value = false;
        }
      } catch (e) {
        log(e.toString());
        errorUpdateProfile.value = true;
        isLoading.value = false;
        errorUpdateProfileText.value = "Đang có lỗi xảy ra";
      }
    }
  }

  Future selectImage(ImageSource source) async {
    file = await imagePicker.pickImage(source: source);
    if (file != null) {
      imageFile = File(file!.path);
      selectImagePath.value = file!.path;
      selectImageSize.value = "${((File(selectImagePath.value)).lengthSync() / 1024 / 1024).toStringAsFixed(2)}Mb";
      double fileLength = File(selectImagePath.value).lengthSync() / 1024 / 1024;
      if (fileLength > 10) {
        Get.snackbar('Lỗi', 'Không thể lấy hình lớn hơn 10mb',
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
        isLoading.value = false;
        return;
      }
      // imageFile = File(file!.path);
      // selectImagePath.value = file!.path;
      // selectImageSize.value =
      //     "${((File(selectImagePath.value)).lengthSync() / 1024 / 1024).toStringAsFixed(2)}Mb";
    } else {
      Get.snackbar('Lỗi', 'Không thể lấy hình ảnh',
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  chooseDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      //initialEntryMode: DatePickerEntryMode.input,
      // initialDatePickerMode: DatePickerMode.year,
      helpText: 'Chọn ngày sinh',
      cancelText: 'Đóng',
      confirmText: 'Xác nhận',
      errorFormatText: 'Nhập ngày hợp lệ',
      errorInvalidText: 'Nhập phạm vi ngày hợp lệ',
      fieldLabelText: 'Ngày Sinh',
      fieldHintText: 'Ngày/Tháng/Năm',
    );
    if (pickedDate != null && pickedDate != selectedDate.value) {
      selectedDate.value = pickedDate;
      dateController!.text = DateFormat('dd/MM/yyyy').format(selectedDate.value).toString();
      print(' dateController!.text ${dateController!.text}');
    }
  }

  // bool disableDate(DateTime day) {
  //   if ((day.isAfter(DateTime.now().subtract(const Duration(days: 1))) &&
  //       day.isBefore(DateTime.now().add(const Duration(days: 5))))) {
  //     return true;
  //   }
  //   return false;
  // }

  bool isDateValid(String date) {
    // Định dạng kiểm tra ngày: dd/MM/yyyy
    const pattern = r'^\d{2}/\d{2}/\d{4}$';
    final regExp = RegExp(pattern);

    if (!regExp.hasMatch(date)) {
      // Chuỗi ngày không khớp với định dạng
      return false;
    }

    // Tiếp theo, kiểm tra xem ngày có hợp lệ không
    final parts = date.split('/');
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (day == null || month == null || year == null) {
      // Ngày, tháng hoặc năm không phải là số hợp lệ
      return false;
    }

    if (month < 1 || month > 12) {
      // Tháng không hợp lệ
      return false;
    }

    if (day < 1 || day > 31) {
      // Ngày không hợp lệ
      return false;
    }

    return true;
  }

  bool isValidPhoneNumber(String phoneNumber) {
    RegExp regex = RegExp(r'^(0|\+84)[1-9]\d{8,9}$');
    if (!regex.hasMatch(phoneNumber)) {
      return false;
    }
    return true;
  }

  setGender(String value) {
    selectedGenderVal.value = value;
  }
}
