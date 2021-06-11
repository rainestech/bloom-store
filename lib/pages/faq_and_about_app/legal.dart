import 'package:bloom/AppTheme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class LegalPage extends StatefulWidget {
  @override
  _LegalPageState createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        title: Text('Legal Information',
          style: TextStyle(
            color: AppColors.themeDark,
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: AppColors.primaryColor,
        iconTheme: IconThemeData(color: AppColors.themeDark),
      ),
      body: ListView(
          children: [
            Container(
              child: Card(
                elevation: 2.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: fullWidth - 20.0,
                      child: Html(
                        data: """
                          <p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">Subscription prices</span></span></span></strong></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">It is free to create a shop and add limited number of products. We take a&nbsp;<strong>5 to 8% commission</strong>&nbsp;on each sale made on The Bloom, in addition to the commission rate on each The Bloom sale. Sellers can choose a subscription plan on a monthly, trimestrial, bi-anual and/ or annual basis. This allows them to have a reduced fee if they choose a plan over multiple months.</span></span></span></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">The different subscription plans available on the App</span></span></span></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">For sellers that make&nbsp;<strong>more than 2000\$\</strong>&nbsp;of sales on a monthly basis, the&nbsp;<strong>commission rate is 10 to 15%</strong>&nbsp;and these sellers are exempt from the subscription. The use of The Bloom services is therefore&nbsp;<strong>free</strong>.</span></span></span></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">Subscription debit</span></span></span></strong></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">The subscription is debited from the seller&rsquo;s The Bloom wallet.</span></span></span></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">It can be triggered in two ways:</span></span></span></span></span></span></p>

<ul>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">A sale made on The Bloom</span></span></strong><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">: When a seller is credited with a sale fee on the wallet.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Direct payment</span></span></strong><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">: When the seller is credited with the fee of a direct payment for a sale outside of The Bloom.</span></span></span></span></span></span></li>
	<li style="text-align:center">
	<hr /></li>
</ul>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:22.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">Order Processing Policy</span></span></span></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">1- Before the order</span></span></span></strong></span></span></span></p>

<ol style="list-style-type:upper-alpha">
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Make sure that the visuals reflect the colors of the product and that these are mentioned in the description and selected as specifications.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Make sure measurements are mentioned in the description.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Ensure that delivery times are the maximum number of days between ordering and receiving by the buyer, including the production time.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Regularly check sizes and stocks to avoid order cancellations. Too many cancellations can lead to your account getting blocked.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">The seller account address is considered a return address by default.</span></span></span></span></span></span></li>
</ol>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">2- Receiving an order (&ldquo;To Accept&rdquo;)</span></span></span></strong></span></span></span></p>

<ol style="list-style-type:upper-alpha">
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">You have 48 hours to accept a sale, or it will be automatically refunded to the buyers on their The Bloom wallet.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">In case of a refusal and cancellation of the order, the seller must provide an explanation to the buyer.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">In case of 3 cancellations over 5 days, the shop is automatically set offline, sellers must reactivate their shop ;</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">In case of 10 cancellations or refunds over 30 days, the seller&#39;s shop can be deactivated or temporarily blocked, and under study to be permanently closed.Sellers must contact customer service.</span></span></span></span></span></span></li>
</ol>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">Order validation (&ldquo;To Ship&rdquo;)</span></span></span></strong></span></span></span></p>

<ol style="list-style-type:upper-alpha">
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">In case of delay in the preparation of the order, the seller&nbsp;<strong>MUST INFORM THE BUYER</strong>. If not, the buyer may contact Customer Service and request an immediate cancellation of the order. The order can then be cancelled without warning to the seller.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">If the production delay is more than 15 days, the designer must send a message at least once a week to the customer to reassure him of the progress.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">When a buyer sends a message, the seller has 48 hours to answer. If they doesn&rsquo;t get any reply, the customer may contact the Customer Service and request an immediate cancellation of the order, without warning the designer.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">After 3 cancellations of this type within 30 days, the seller may lose its &ldquo;verified seller&rdquo; status and can see their shop closed.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">For clothing order: the designer must send a message to confirm the size and measurements of the buyer. In case of shipping without confirmation, if the buyer is not statisfied with the size, the product is considered as &ldquo;non compliant&rdquo; =&gt; Therefore,&nbsp;<strong>the seller bears the shipping cost of returning the product</strong>.</span></span></span></span></span></span></li>
</ol>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">Shipping order (&ldquo;Shipped&rdquo;)</span></span></span></strong></span></span></span></p>

<ol style="list-style-type:upper-alpha">
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">It is strongly recommended</span></span></strong><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">&nbsp;to ship your orders with a tracking number. Otherwise, in case of loss of package or non-receipt or loss of package, the customer may request cancellation and full refund of the order, as no proof of shipment.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">A buyer sends a message, the designer has 48 hours max to answer. In case of no reply, the customer can contact the Customer Service and request an immediate cancellation of the order without warning the seller. After 5 cancellations of this type within 30 days, the seller loses its status of verified seller and can see his shop closed after 10 cancellations.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Sellers are responsible for shipping the sold items to their buyers. No matter which shipping or logistics service or carrier they use,&nbsp;<strong>it is their entire responsibility to ensure that the buyers receives the items purchased in thier shop</strong>.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">In case the buyer does not receive an order, the seller must all initiate the steps with the shipping carrier or service selected. When there is a tracking number and it indicates that the product was received, the seller is not required to refund; even if the buyer indicates not to have received it,.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Customs fees: It is possible that a buyer will be asked to or required to pay customs fees upon delivery. If the buyer refuses a delivery because of these fees</span></span></strong><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">, he/she may ask to be fully refunded because he is not responsible for the shipping method chosen by the seller. For the shipping of The Bloom orders, the buyer can contact Customer Service to find a solution to deal with these customs fees. For other sales, like direct payment sales for example, it is up to the seller to warn the buyer in advance and provide a solution that the buyer can accept or refuse.</span></span></span></span></span></span></li>
</ol>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">Return of parcels for exchange or cancellation</span></span></span></strong></span></span></span></p>

<ol style="list-style-type:upper-alpha">
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">If a customer wants to return a product that proves to be non-compliant, the return costs are the responsibility of the seller.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">A buyer makes a return request to receive the seller&rsquo;s return address, the seller has upto 48 hours to answer to accept or refuse this request. If the seller doesn&rsquo;t receive a reply in this time frame, the customer may contact Customer Service and request a default return address or an immediate cancellation of the order without warning the seller. After 5 cancellations of this type within 30 days, the seller may lose its &ldquo;verified seller&rdquo; status and can see his/her shop closed temporarily or permanently after 10 cancellations.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">If a customer requests a return address,the delivery address will be given by default, if the seller has not provided a return address.<strong>If the package is sent to the wrong address, it will still be considered as &ldquo;Returned&rdquo;</strong>, as the seller is responsible for keeping the return addresses up to date on his/her shop profile.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Once an order has been returned, the seller has 15 days to confirm receipt or warn the buyer that it has not been received.&nbsp;<strong>Otherwise, the package is considered as returned</strong>.</span></span></span></span></span></span></li>
</ol>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">Definition of &quot;Non-compliant&quot; product</span></span></span></strong></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">If the seller sends a product and it turns out to be non-compliant, the seller bears the cost of the return shipping fees and fully refund the order.</span></span></span></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">A product is considered &quot;non-compliant&quot; if one of the requirements stated below applies and/or the customer provides evidence that:</span></span></span></span></span></span></p>

<ul>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">the product arrived damaged</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">there is a manufacturing default</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">the color of the item received is different from the color shown in the product picture online or if the measurements were missing or incorrect</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">the product is not the same as the one shown on the product picture</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">the material and other descriptive elements are different from what is stated in the product picture (example : you say that it is silk but in reality it is not.)</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">the measurements were not confirmed before the item was sent to the buyer, especially for custom clothing</span></span></span></span></span></span></li>
</ul>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:22.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">Products Policy</span></span></span></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">The Bloom reserves the right to disable products that do not respect the list of authorized products, and those reported as copying or plagiarism. If this happens several times at the same seller,then he/she risks getting his/her shop temporarily or permanently disabled/blocked.</span></span></span></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">Please find below details of our product acceptance policy.</span></span></span></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">1- Unauthorized products</span></span></span></strong></span></span></span></p>

<ol style="list-style-type:upper-alpha">
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Whitening or potentially harmful cosmetic products.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Products whose photos are not clear or of sufficient quality</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Prohibited products defined in the&nbsp;</span></span><a href="https://www.afrikrea.com/en/pages/terms" target="_blank"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:blue">General Use Conditions</span></span></span></a><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">Fashion, art and craft products that do not fit The Bloom&#39;s African inspired&rsquo;s definition.</span></span></span></span></span></span></li>
</ol>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">2- African inspired product on The Bloom</span></span></span></strong></span></span></span></p>

<ol style="list-style-type:upper-alpha">
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">A product is considered &ldquo;inspired by Africa&rdquo; when it meets the following conditions:</span></span></span></span></span></span>

	<ul style="list-style-type:circle">
		<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">It is composed of African materials of origin or use, whether it is the fabrics, pearls, patterns or other components of the product.</span></span></span></span></span></span></li>
		<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">It conveys a message or meaning clearly related to African or &ldquo;Afro&rdquo; culture. C. Cosmetics and food products with a message or meaning clearly related to African or &ldquo;Afro&rdquo; culture.</span></span></span></span></span></span></li>
		<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">All products that the The Bloom team accepts to describe as an African inspired craft</span></span></span></span></span></span></li>
	</ul>
	</li>
</ol>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:18.0pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:#00aa5b">Plagiarism and copyright rules on The Bloom</span></span></span></strong></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">The products considered as being a copy or plagiarized by the The Bloom team will be automatically disabled. If this happens several times to the same seller, then he/she risks getting his/her shop temporarily or permanently disabled/blocked.</span></span></span></span></span></span></p>

<p><span style="font-size:11pt"><span style="background-color:white"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif"><span style="color:black">You can report any product that is a copy or has been plagiarized by going on the product page and clicking on&nbsp;<strong><em>&quot;Report this product to The Bloom&quot;</em></strong>, below the &quot;Contact the seller&quot; tab.</span></span></span></span></span></span></p>

<ol style="list-style-type:upper-alpha">
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">The products qualified as copy or plagiarism by The Bloom team will be automatically disabled. And if it happens several times at the same seller, it&#39;s his shop that may be disabled. You have the possibility to report any creation that would be a copy or plagiarism, by going to the page of this product, and clicking on &quot;Report this product to The Bloom&quot;, below the &quot;Contact the seller&quot; button.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><strong><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">It is forbidden to use photos of other brands or sites</span></span></strong><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">. You must only to put pictures that belong to you.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">You are not allowed to offer products identical to those of another existing brand on The Bloom.</span></span></span></span></span></span></li>
	<li><span style="font-size:11pt"><span style="background-color:white"><span style="color:black"><span style="font-family:Calibri,sans-serif"><span style="font-size:10.5pt"><span style="font-family:&quot;Arial&quot;,sans-serif">We also encourage you to help by &quot;flagging&quot; products that do not comply with this policy. To do this, you need to go to the product page of this product, and click on&nbsp;<strong><em>&quot;Report this product to The Bloom&quot;</em></strong>, below the &quot;Contact the seller&quot; tab.</span></span></span></span></span></span></li>
</ol>

<p>&nbsp;</p>

                        """,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]
      )
    );
  }
}
