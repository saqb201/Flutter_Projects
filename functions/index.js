const functions = require("firebase-functions");
const stripe = require("stripe")("YOUR_STRIPE_SECRET_KEY"); // <-- Replace with your Stripe secret key

// Limit maximum concurrent instances to control cost
functions.setGlobalOptions({ maxInstances: 10 });

// Stripe payment intent function
exports.createPaymentIntent = functions.https.onRequest(async (req, res) => {
  try {
    const { amount, currency } = req.body;

    // Create payment intent
    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
      automatic_payment_methods: {enabled: true},
    });

    res.status(200).send({ clientSecret: paymentIntent.client_secret });
  } catch (error) {
    console.error(error);
    res.status(400).send({ error: error.message });
  }
});
