## Adding a new email

Add the email in ../default.nix and ../secrets.nix

Create the password hash

```bash
mkpasswd
```

Add the hash to a new secret file

```bash
agenix -e mail-passwords/secret-file.age
```

remember to add the account in the mail server config
