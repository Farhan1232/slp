import 'package:flutter/material.dart';

class FaceAndJawScreen extends StatelessWidget {
  const FaceAndJawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الوجه والفكين',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'تحريك الشفاه للأمام وللخلف',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'النفخ على الشمعة 🕯️',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'نفخ البالون 🎈',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'ابتسامة واسعة: الابتسام بأقصى ما يمكن مع إبقاء الأسنان مرئية.',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'رفع اللسان: رفع طرف اللسان إلى سقف الفم ثم خفضه للأسفل.',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'المد على الجوانب: لمس طرف اللسان للجانب الأيمن ثم الأيسر من الفم.',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'دوران اللسان: تحريك اللسان في دائرة حول الأسنان العليا والسفلى.',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'خارج الفم: إخراج اللسان ثم سحبه بسرعة للداخل.',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'النفخ والشفط: نفخ الخدين ثم شفط الهواء داخليًا وكأنك ترسم على الخدين.',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'تضخيم الخدين: إدخال الهواء في الخد الأيمن ثم الأيسر بالتبادل.',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'فتح وغلق الفم ببطء: فتح الفم على وسع ثم غلقه ببطء مع التحكم بالحركة.',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'حركات جانبية: تحريك الفك إلى اليمين ثم إلى اليسار ببطء.',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
              Text(
                'تمرين المضغ الوهمي: تحريك الفك كما لو تمضغ طعامًا مع فتح الفم وغلقه.',
                textDirection: TextDirection.rtl,
                style: TextStyle(fontSize: 18, height: 1.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
