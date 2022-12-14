#Enable OIDC / JWT for GitHub Actions Workflow

resource "vault_jwt_auth_backend" "github_actions" {
  description        = "This is GitHub Actions JWT"
  path               = "jwt"
  oidc_discovery_url = "https://token.actions.githubusercontent.com"
  bound_issuer       = "https://token.actions.githubusercontent.com"
  default_role       = "github-actions"
  namespace          = data.terraform_remote_state.vault_infra.outputs.namespace
}

resource "vault_jwt_auth_backend_role" "github_actions" {
  backend        = vault_jwt_auth_backend.github_actions.path
  role_name      = "github-actions"
  token_policies = [vault_policy.vault_actions.name]

  bound_claims_type = "glob"
  bound_claims = {
    sub : "repo:cedricfeist/terraform-vault-packer:ref:refs/*"
  }

  bound_audiences = ["https://github.com/cedricfeist"]

  user_claim = "workflow"
  role_type  = "jwt"
  token_ttl  = "1800"
  namespace  = data.terraform_remote_state.vault_infra.outputs.namespace
}
