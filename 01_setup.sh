#Set Up Repo
done!
#Start HCP Vault Cluster
terraform config done!

#Next Step: 
requirements for README 
- terraform login --> TFC API TOKEN 
- export AWS & HCP ENV VARIABLES 

toDo: golden image packer --> hcp Vault --> dynamic aws creds 


#create github oidc config
vault write auth/jwt/config \
     oidc_discovery_url="https://token.actions.githubusercontent.com" \
     bound_issuer="https://token.actions.githubusercontent.com" \
     default_role="demo"

vault write auth/jwt/role/demo -<<EOF
{
    "role_type": "jwt",
    "bound_subject": "",
    "bound_claims": {
        "sub": ["repo:lomar92/packer-vault-githubactions:ref:refs/*"]
    },
    "bound_claims_type": "glob",
    "bound_audiences": "https://github.com/lomar92",
    "user_claim": "workflow",
    "policies": "hcp-root",
    "ttl": "1h"
}
EOF