class PaymentInfo {
  String amount;
  String cardNumber;
  String cardExpiryDate;
  String cardCVV;
  String customerAddress;
  String customerPostCode;

  PaymentInfo({
    this.amount,
    this.cardNumber,
    this.cardExpiryDate,
    this.cardCVV,
    this.customerAddress,
    this.customerPostCode,
  });
}
