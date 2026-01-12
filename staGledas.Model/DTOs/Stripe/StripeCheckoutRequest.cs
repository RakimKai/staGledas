namespace staGledas.Model.DTOs.Stripe
{
    public class StripeCheckoutRequest
    {
        public string? SuccessUrl { get; set; }
        public string? CancelUrl { get; set; }
    }

    public class StripeCheckoutResponse
    {
        public string? SessionId { get; set; }
        public string? Url { get; set; }
    }

    public class PaymentSheetResponse
    {
        public string? PaymentIntent { get; set; }
        public string? EphemeralKey { get; set; }
        public string? Customer { get; set; }
        public string? PublishableKey { get; set; }
    }
}
