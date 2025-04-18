// Used in Billing/billing.dart

//interface of strategy
abstract class BillingStrategy {
  double getFinalAmount(double amount);
  String getDescription();
}

// Concrete Strategies
class RegularBilling implements BillingStrategy {
  @override
  double getFinalAmount(double amount) => amount;

  @override
  String getDescription() => "SSLCommerz (No Discount)";
}

class BasicDiscountBilling implements BillingStrategy {
  @override
  double getFinalAmount(double amount) => amount * 0.9; // 10% discount

  @override
  String getDescription() => "Bkash (10% Off)";
}

class PremiumDiscountBilling implements BillingStrategy {
  @override
  double getFinalAmount(double amount) => amount * 0.85; // 15% discount

  @override
  String getDescription() => "Visa/Master Card (15% Off)";
}

// Context - uses the strategy
class BillingContext { // <----------------
  BillingStrategy _strategy;

  BillingContext(this._strategy);

  void setStrategy(BillingStrategy strategy) {
    _strategy = strategy;
  }

  double calculateBill(double amount) => _strategy.getFinalAmount(amount);
  String getStrategyDescription() => _strategy.getDescription();
}