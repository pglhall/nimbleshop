description = %Q{
<p>
  Authorize.Net is a payment gateway service provider allowing merchants
  to accept credit card and electronic checks paymentsn. Authorize.Net
  claims a user base of over 305,000 merchants, which would make them
  the Internet's largest payment gateway service provider.
</p>

<p>
  It also provides an instant test account which you can use while
  your application is being processed.
</p>
}

PaymentMethod.create!(name: 'Authorize.net', description: description)

description = %Q{
<p>
  Paypal website payments standard is a payment solution provided by
  paypal which allows merchant to accept credit card and paypal payments.
  There is no monthly fee and no setup fee by paypal for this account.
</p>

<p>
  <a href='https://merchant.paypal.com/cgi-bin/marketingweb?cmd=_render-content&content_ID=merchant/wp_standard&nav=2.1.0'>
   more information
  </a>
</p>
}

PaymentMethod.create!(name: 'Paypal website payments standard', description: description)
