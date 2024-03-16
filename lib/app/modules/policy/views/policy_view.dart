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
          'I have been using Product A for the past year and I am extremely satisfied with it. The customer support is excellent and the product itself is top-quality. I highly recommend it to anyone in need of a reliable and efficient solution.'),
      Testimonial('Jane Doe',
          'I was skeptical about Product B at first, but after using it for a few weeks I am pleasantly surprised. It is easy to use and customize, and it has saved me a lot of time and effort. I will definitely be using it again in the future.'),
      Testimonial('Bob Johnson',
          'Product C exceeded my expectations. Not only is it energy efficient, but it is also environmentally friendly. I feel good about using it and will be recommending it to my friends and family.'),
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
                    'Our company offers a wide range of high-quality products and services to meet the needs of our customers.',
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
                        'Mission Statement:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Our mission is to provide high-quality products and services to our customers.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Values:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Customer satisfaction is our top priority'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('We strive for continuous improvement'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('We value honesty and integrity in all our actions'),
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
                        'History:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Founded in 2010'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Started as a small business with a few employees'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Grown into a successful and well-respected organization'),
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
                        'Products:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Product A: High-quality and durable'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Product B: Easy to use and customize'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Product C: Energy efficient and environmentally friendly'),
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
                        'Awards:',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(height: 8),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Best Product Award 2020'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Innovation of the Year 2021'),
                      ),
                      ListTile(
                        leading: Icon(Icons.check),
                        title: Text('Customer Satisfaction Award 2022'),
                      ),
                    ],
                  )),

              //Testimonials or reviews
              Container(
                width: screenWidth,
                padding: EdgeInsets.all(8),
                child: Text(
                  'Testimonials:',
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
                        'Contact Us:',
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
