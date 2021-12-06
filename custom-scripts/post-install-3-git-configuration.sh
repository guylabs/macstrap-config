#!/bin/sh
set -e


printf "\033[1mPlease select if you want to setup Git commit signing with Github\033[0m:\n"
echo "[1] Yes (for new installs)"
echo "[2] No (in case you already have it configured or port it from a backup)"
echo

printf "Enter your decision: "
applyConfiguration=$(readInput "1")
echo

case $applyConfiguration in
    "1")
        echo "The next steps configure GIT and commit sigining. Please provide the necessary information when prompted."
        echo
        printf "Full name (e.g. Jaohne Doe): "
        fullName=$(readInput "Jaohne Doe")

        git config --global user.name "$fullName"

        printf "Gradle email (e.g. jdoe@gradle.com): "
        email=$(readInput "jdoe@gradle.com")

        git config --global user.email "$email"

        echo
        echo "Generating GPG key for GIT commit signing ..."
        echo

        gpg --full-generate-key --expert << EOF
    Key-Type: EDDSA
      Key-Curve: ed25519
    Subkey-Type: ECDH
      Subkey-Curve: cv25519
    Name-Real: $fullName
    Name-Email: $email
    Expire-Date: 0
    %commit
EOF

        echo
        echo "Successfully created GPG key. Configuring GIT to use it for commit signing."
        echo
        echo

        sigingKey=$(gpg --list-secret-keys --keyid-format=long | sed -n 's/.*ed25519\/\([A-Z0-9]*\) .*/\1/p')
        git config --global user.signingkey "$sigingKey"
        git config --global commit.gpgsign true
        gpg --armor --export "$sigingKey"

        echo
        echo "Copy your GPG key, beginning with -----BEGIN PGP PUBLIC KEY BLOCK----- and ending with -----END PGP PUBLIC KEY BLOCK-----."
        echo "Follow this guide to add it to Github:"
        echo "  https://docs.github.com/en/authentication/managing-commit-signature-verification/adding-a-new-gpg-key-to-your-github-account"
        echo
        echo "Once done, press Enter to continue."
        readInput "0"
        ;;
    *)
        echo
        printf "\033[1mSkipped setting up GIT commit singing\033[0m\n"
        ;;
esac
