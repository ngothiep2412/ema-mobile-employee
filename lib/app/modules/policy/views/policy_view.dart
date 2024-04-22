import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:hrea_mobile_employee/app/base/base_view.dart';
import 'package:hrea_mobile_employee/app/resources/color_manager.dart';

import '../controllers/policy_controller.dart';

class PolicyView extends BaseView<PolicyController> {
  const PolicyView({Key? key}) : super(key: key);
  @override
  Widget buildView(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    final List<Testimonial> testimonials = [
      Testimonial('John Smith',
          'Tôi đã sử dụng Sản phẩm EMA trong năm qua và tôi vô cùng hài lòng với nó. Hỗ trợ khách hàng là tuyệt vời và bản thân sản phẩm có chất lượng hàng đầu. Tôi đặc biệt giới thiệu nó cho bất kỳ ai cần một giải pháp đáng tin cậy và hiệu quả.'),
      Testimonial('Jane Doe',
          'Lúc đầu, tôi nghi ngờ về Sản phẩm EMA, nhưng sau khi sử dụng được vài tuần, tôi rất ngạc nhiên. Nó rất dễ sử dụng và tùy chỉnh, đồng thời nó đã giúp tôi tiết kiệm rất nhiều thời gian và công sức. Tôi chắc chắn sẽ sử dụng nó một lần nữa trong tương lai.'),
      Testimonial('Bob Johnson',
          'Sản phẩm EMA vượt quá sự mong đợi của tôi. Nó không chỉ tiết kiệm năng lượng mà còn thân thiện với môi trường. Tôi cảm thấy hài lòng khi sử dụng và sẽ giới thiệu cho bạn bè, người thân.'),
    ];

    return Scaffold(
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              //Name and Logo
              Container(
                width: screenWidth,
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Image.asset(
                    //   Helper.getAssetName("fbus.png"),
                    //   width: 280,
                    // ),
                    Text(
                      'EMA',
                      style: TextStyle(
                        fontSize: 20,
                        color: ColorsManager.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),

              //brief summary
              Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Công ty chúng tôi cung cấp nhiều loại sản phẩm và dịch vụ chất lượng cao để đáp ứng nhu cầu của khách hàng.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )),

              //statement and values
              Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tuyên bố sứ mệnh: ',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Sứ mệnh của chúng tôi là cung cấp các sản phẩm và dịch vụ chất lượng cao cho khách hàng.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Những giá trị: ',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Sự hài lòng của khách hàng là ưu tiên hàng đầu của chúng tôi'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Chúng tôi nỗ lực cải tiến liên tục'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Chúng tôi coi trọng sự trung thực và liêm chính trong mọi hành động của mình'),
                      ),
                    ],
                  )),

              //History and background
              Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lịch sử:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Được thành lập vào năm 2024'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Bắt đầu từ một doanh nghiệp nhỏ với một vài nhân viên'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Phát triển thành một tổ chức thành công và được tôn trọng'),
                      ),
                    ],
                  )),

              //products or service
              Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sản phẩm:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Chất lượng cao và bền'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Dễ sử dụng và tùy chỉnh'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Tiết kiệm năng lượng và thân thiện với môi trường'),
                      ),
                    ],
                  )),

              //awards
              Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Những giải thưởng:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Giải thưởng Sản phẩm Tốt nhất 2024'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Đổi mới của năm 2024'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Giải thưởng Sự hài lòng của Khách hàng 2024'),
                      ),
                    ],
                  )),

              //Testimonials or reviews
              Container(
                width: screenWidth,
                padding: EdgeInsets.all(8),
                child: Text(
                  'Lời chứng thực:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                width: screenWidth,
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: testimonials.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              testimonials[index].author,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            SizedBox(height: 4),
                            Text(
                              testimonials[index].text,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              //contact information
              Container(
                  width: screenWidth,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Liên hệ với chúng tôi:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.location_on),
                        title: Text('FPT University Ho Chi Minh'),
                        subtitle: Text('FPT University, District 9'),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text('(84) 123-456-7890'),
                      ),
                      ListTile(
                        leading: Icon(Icons.email),
                        title: Text('ema@gmail.com'),
                      ),
                    ],
                  )),

              //social media
              // Container(
              //     width: screenWidth,
              //     padding: EdgeInsets.all(8),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           'Follow Us:',
              //           style: Theme.of(context).textTheme.titleLarge,
              //         ),
              //         SizedBox(height: 8),
              //         ListTile(
              //           leading: Icon(Icons.link),
              //           title: Text('Facebook'),
              //           onTap: () => launchUrl(
              //               Uri.parse('https://www.facebook.com/yourpage')),
              //         ),
              //         ListTile(
              //           leading: Icon(Icons.link),
              //           title: Text('Twitter'),
              //           onTap: () => launchUrl(
              //               Uri.parse('https://www.twitter.com/yourpage')),
              //         ),
              //         ListTile(
              //           leading: Icon(Icons.link),
              //           title: Text('Instagram'),
              //           onTap: () => launchUrl(
              //               Uri.parse('https://www.instagram.com/yourpage')),
              //         ),
              //       ],
              //     )),
            ],
          ),
        ));
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: ColorsManager.backgroundContainer,
      leading: IconButton(
        onPressed: () {
          Get.back();
          controller.onDelete();
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: ColorsManager.primary,
        ),
      ),
    );
  }
}

class Testimonial {
  final String author;
  final String text;

  Testimonial(this.author, this.text);
}
