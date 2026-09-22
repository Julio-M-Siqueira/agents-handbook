# External service boundary

Build an adapter that keeps a payment provider's data model and failures out of checkout code.

## Goal

Implement `ProviderPayments.authorize`. It must call the supplied provider client, return the provider authorization ID on success, and expose only the domain failures defined in `starter/payments.py`.

## Constraints

- `Checkout` must depend on the `Payments` protocol only.
- Do not return provider response dictionaries or raise provider exceptions from the adapter.
- Treat a provider response with `status == "declined"` as `PaymentDeclined`.
- Translate `ProviderTimeout` to `PaymentUnavailable` while preserving it as the cause.

## Acceptance checks

Run `python -m unittest discover -s tests -v` from this exercise directory. The success, decline, and timeout tests must pass.

## Hints

1. List the vocabulary checkout needs: authorization ID, declined payment, and unavailable payment.
2. Keep the provider response shape inside `ProviderPayments`.
3. Use `raise DomainError(...) from error` when translating a timeout.

## Source and guidance

Based on [How to Stop Third-Party APIs From Ruining Your Code](https://www.youtube.com/watch?v=vskwNNdnqMc), especially 09:54–10:45. Read [[External Service Boundary]] before starting.
