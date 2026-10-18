# Algotrading model handoff

This is project context for **Audit Model Serving and Execution**, not a second review workflow. Read current producer/consumer code and configuration before treating field names or artifacts as verified.

## Ownership and artifacts

- `algotrading-research` owns offline training; `algotrading-core` holds shared signal/feature logic; `algotrading-backend` owns inference and execution.
- The legacy handoff uses a joblib model (`model_path`), an ordered feature file (`features_path` / `side_features`), and `cv_metrics.json`. Verify that model and feature list come from the same training run.
- Backend `config/inference.yaml`, `inference/schemas/config.py`, and `inference/model_loader.py` own artifact selection and loading. Current schemas distinguish side and optional size models; flat `model.s3_uri` / `model.local_path` may be deprecated aliases. Resolve current keys from the schema.
- When research uses `s3_feature_store`, compare its layout and feature order with `AwsS3FeatureWriter` and serving consumers.
- When used, MLflow run/registry identity and DVC data/output revisions supply provenance. MLflow tracking serialization is not automatically the joblib artifact consumed by serving. Inspect the actual exported artifact.

## Promotion evidence

Identify the built model, ordered features, preprocessing, training revision/run, and rollback configuration. Check live parity including missing values and categorical encoding. A promotion changes serving configuration to an identified built artifact; it should not silently retrain.

Verify development/paper/live separation, risk-parameter history, and the existing promotion authorization contract. Keep secrets in environment/secret-manager boundaries; record safe identifiers instead of credential-bearing payloads.

These details originated in the retired MLOps skill. Research-side paths and optional tracking tools must be rechecked against the relevant repository when used.
