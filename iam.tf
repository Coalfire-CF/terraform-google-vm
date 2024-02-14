resource "google_kms_crypto_key_iam_member" "crypto_key_encrypter" {
  crypto_key_id = var.disk_encryption_key
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${var.service_account.email}"
}
