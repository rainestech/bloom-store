import 'package:bloom/AppTheme/theme.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final faqList = [
    {
      'question': 'Who we are',
      'answer':
          'Bloom was created in 2021 with one mission in mind: bridge Africa and the World. Bloom is an ecommerce platform created to support African business communities from different pools of market under a single marketplace. The aim is to showcase African products where buyers meet sellers without any boundaries. The platform will bring together thousands of sellers from Africa and all over the world with the aim to reach customers globally.'
    },
    {
      'question': 'What we do',
      'answer':
          'We promote financial empowerment for Africans through ecommerce. We also provide a safer shopping experience and outstanding customer service for our customers. This enables customers to shop with trust and ease on our platform. Bloom promotes integrity, openness and equal rights to sell and buy thus creating peaceful co-existence between all parties. \n Safely shop for clothing, jewellery, art and modern accessories directly from designer boutiques inspired by Africa with delivery anywhere in the world. If you want a customized seller platform, seamless coordination of global payments and easy shipping tools, you\'re at the right place! '
    }
  ];

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        title: Text('About Us',
          style: TextStyle(
            color: AppColors.themeDark,
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.themeDark),
      ),
      body: ListView.builder(
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final item = faqList[index];
          return Container(
              child: Card(
                elevation: 2.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: fullWidth - 20.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${item['question']}',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, right: 8.0, left: 8.0, bottom: 8.0),
                            child: Text(
                              '${item['answer']}',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 14.0,
                                height: 1.6,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
        },
      ),
    );
  }
}
