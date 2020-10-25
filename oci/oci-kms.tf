resource "oci_kms_vault" "ph-kms-vault" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  display_name            = "${var.ph_prefix}-vault"
  vault_type              = "DEFAULT"
}

resource "oci_kms_key" "ph-kms-key-storage" {
  compartment_id          = oci_identity_compartment.ph-compartment.id
  display_name            = "${var.ph_prefix}-key-storage"
  management_endpoint     = oci_kms_vault.ph-kms-vault.management_endpoint
  key_shape {
    algorithm               = "AES"
    length                  = 32
  }
  protection_mode         = "SOFTWARE"
}

resource "oci_kms_encrypted_data" "ph-kms-ph-secret" {
  crypto_endpoint         = oci_kms_vault.ph-kms-vault.crypto_endpoint
  key_id                  = oci_kms_key.ph-kms-key-storage.id
  plaintext               = var.ph_password
}
